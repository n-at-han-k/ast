require_relative "boot"

module OpenapiFirst
  class Definition
    def deconstruct_keys(_requested)
      info = self["info"] || {}
      components = self["components"] || {}

      {
        openapi: self["openapi"],
        title: info["title"],
        version: info["version"],
        description: info["description"],
        servers: self["servers"] || [],
        security: self["security"] || [],
        security_schemes: components["securitySchemes"] || {},
        schemas: components["schemas"] || {},
        templates: paths,
        routes: routes.to_a,
      }
    end

    def deconstruct
      routes.to_a
    end
  end

  class Router
    class Route
      def deconstruct_keys(_requested)
        defined_requests = requests.to_a
        defined_responses = responses.to_a

        {
          method: request_method.upcase,
          path:,
          item: path.end_with?("}"),
          templated: path.include?("{"),
          operation_id: defined_requests.first&.operation_id,
          tags: defined_requests.flat_map { |request| request.operation["tags"] || [] }.uniq,
          summary: defined_requests.first&.operation&.[]("summary"),
          deprecated: defined_requests.any? { |request| request.operation["deprecated"] == true },
          security: defined_requests.first&.security,
          params: defined_requests.flat_map(&:parameters).uniq(&:name),
          requests: defined_requests,
          responses: defined_responses,
          statuses: defined_responses.map(&:status).uniq,
          content_types: defined_requests.filter_map(&:content_type),
        }
      end
    end
  end

  class Request
    def security
      operation["security"]
    end

    def ref
      value = content_schema&.value
      value["$ref"]&.split("/")&.last if value.is_a?(Hash)
    end

    def deconstruct_keys(_requested)
      {
        operation_id:,
        method: request_method.upcase,
        path:,
        content_type:,
        required_body: !allow_empty_content?,
        body: content_schema&.value,
        ref:,
        params: parameters,
        tags: operation["tags"] || [],
        summary: operation["summary"],
        deprecated: operation["deprecated"] == true,
        security:,
      }
    end

    def deconstruct
      parameters
    end
  end

  class Response
    def ref
      value = content_schema&.value
      value["$ref"]&.split("/")&.last if value.is_a?(Hash)
    end

    def deconstruct_keys(_requested)
      {
        status:,
        content_type:,
        body: content_schema&.value,
        ref:,
        headers: headers || {},
      }
    end
  end

  class Parameter
    def deconstruct_keys(_requested)
      {
        name:,
        location:,
        required: required?,
        deprecated: deprecated?,
        type:,
        enum: schema && schema["enum"],
        schema:,
      }
    end
  end
end
