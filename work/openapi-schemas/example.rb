require_relative "openapi_patterns"
require "json"

DOCUMENT = ARGV.fetch(0, File.expand_path("api-1.json", __dir__))

def shape(route)
  case route
  in {method: "GET", item: false, params: [*, {name: "page" | "offset" | "cursor"}, *]}
    :paged_list
  in {method: "GET", item: false}
    :list
  in {method: "GET", item: true}
    :read
  in {method: "POST", item: true, requests: [{content_type: nil}, *] | []}
    :item_action
  in {method: "POST", item: true}
    :item_create
  in {method: "POST", templated: true}
    :scoped_create
  in {method: "POST"}
    :create
  in {method: "PUT", item: true}
    :replace
  in {method: "PUT"}
    :upsert
  in {method: "PATCH"}
    :update
  in {method: "DELETE"}
    :delete
  in {method:}
    method.downcase.to_sym
  end
end

def auth(route)
  case route
  in {security: nil}
    "global"
  in {security: []}
    "public"
  in {security: [schemes]}
    schemes.keys.join("+")
  in {security: [*] => alternatives}
    alternatives.map { |scheme| scheme.keys.join("+") }.join(" | ")
  end
end

def body(route)
  case route
  in {requests: []} | {requests: [{content_type: nil}, *]}
    nil
  in {requests: [{content_type:, required_body: true, ref: String => ref}, *]}
    format("%s (%s, required)", ref, content_type)
  in {requests: [{content_type:, ref: String => ref}, *]}
    format("%s (%s)", ref, content_type)
  in {requests: [{content_type:, body: {} => inline}, *]}
    format("inline %s (%s)", inline["type"] || "schema", content_type)
  in {requests: [{content_type:}, *]}
    content_type
  end
end

def success(route)
  case route
  in {responses: [*, {status: /\A2/ => status, ref: String => ref}, *]}
    format("%s %s", status, ref)
  in {responses: [*, {status: /\A2/ => status, content_type: String => type}, *]}
    format("%s %s", status, type)
  in {responses: [*, {status: /\A2/ => status}, *]}
    status
  in {statuses: []}
    "undocumented"
  in {statuses: [*] => statuses}
    statuses.join(",")
  end
end

def errors(route)
  case route
  in {statuses: [*, /\A4/, *] => statuses} if statuses.any? { |status| status.start_with?("5") }
    "4xx+5xx"
  in {statuses: [*, /\A4/, *]}
    "4xx"
  in {statuses: [*, "default", *]}
    "default only"
  else
    "none"
  end
end

def params(route)
  grouped = route.deconstruct_keys(nil)[:params].group_by(&:location)

  %w[path query header cookie].filter_map do |location|
    found = grouped[location]
    next unless found

    format("%s:%d", location, found.size)
  end.join(" ")
end

def finding(route)
  case route
  in {deprecated: true, operation_id:}
    [:deprecated, operation_id]
  in {method: "POST" | "PUT" | "PATCH", requests: [] | [{content_type: nil}, *], operation_id:}
    [:write_without_body, operation_id]
  in {security: [], operation_id:}
    [:unauthenticated, operation_id]
  in {statuses: [] | [/\A2/], operation_id:}
    [:no_error_responses, operation_id]
  in {method: "GET", item: false, params:, operation_id:} if params.none? { |param| param.name == "page" }
    [:unpaged_collection, operation_id]
  in {params: [*, {location: "path", required: false, name:}, *], operation_id:}
    [:optional_path_param, format("%s (%s)", operation_id, name)]
  else
    nil
  end
end

def describe_scheme(name, scheme)
  kind = scheme["type"]
  kind = format("%s/%s", kind, scheme["scheme"]) if scheme["scheme"]
  format("%s (%s)", name, kind)
end

definition = OpenapiFirst.parse(JSON.load_file(DOCUMENT), filepath: DOCUMENT)
routes = definition.routes.to_a

case definition
in {openapi:, title:, version:, templates:, schemas:, servers:, security:, security_schemes:}
  puts format("%s %s - OpenAPI %s", title, version, openapi)
  puts format("  servers:  %s", servers.map { |server| server["url"] }.join(", "))
  puts format("  schemes:  %s", security_schemes.map { |name, scheme| describe_scheme(name, scheme) }.join(", "))
  puts format("  default:  %s", security.flat_map(&:keys).uniq.join(" | "))
  puts format("  surface:  %d path templates, %d operations, %d component schemas",
              templates.size, routes.size, schemas.size)
end

puts
puts "endpoints"

routes.group_by { |route| route.deconstruct_keys(nil)[:tags].first || "untagged" }.sort.each do |tag, tagged|
  puts format("  %s (%d)", tag, tagged.size)

  tagged.sort_by { |route| [route.path, route.request_method] }.each do |route|
    puts format(
      "    %-6s %-44s %-16s %-26s %-13s %-7s %-16s %s",
      route.request_method.upcase,
      route.path,
      shape(route),
      success(route),
      errors(route),
      auth(route),
      params(route),
      body(route) || "-"
    )
  end
end

puts
puts "shapes"
routes.group_by { |route| shape(route) }.sort_by { |_shape, found| -found.size }.each do |kind, found|
  puts format("  %-20s %3d", kind, found.size)
end

puts
puts "findings"
routes.filter_map { |route| finding(route) }.group_by(&:first).sort.each do |kind, found|
  puts format("  %s (%d)", kind, found.size)
  found.first(8).each { |(_kind, detail)| puts format("    %s", detail) }
  puts "    ..." if found.size > 8
end

referenced = File.read(DOCUMENT).scan(%r{components/schemas/([A-Za-z0-9_.-]+)}).flatten.tally
schemas = definition.deconstruct_keys(nil)[:schemas]
hottest = referenced.sort_by { |_name, count| -count }.first(8)

puts
puts "component schemas"
puts format("  referenced:   %d of %d", referenced.size, schemas.size)
puts format("  unreferenced: %s", (schemas.keys - referenced.keys).sort.join(", "))
puts format("  hottest:      %s", hottest.map { |name, count| format("%s (%d)", name, count) }.join(", "))
