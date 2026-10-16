REFS = File.expand_path("../../refs", __dir__)

GEM_PATH = ENV["OAS_GEM_PATH"] || File.expand_path("vendor/gems", __dir__)

MISSING_DEPS = <<~MESSAGE
  %s

  openapi_first and json_schemer are loaded from the refs/ checkouts, but their
  third-party dependencies are not part of the nix bundlerEnv. Install them once:

    gem install --no-document -i %s hana bigdecimal simpleidn rack

  or point OAS_GEM_PATH at a directory that already has them.
MESSAGE

(Dir["#{GEM_PATH}/gems/*/lib"] + Dir["#{GEM_PATH}/extensions/*/*/*"]).each do |dir|
  $LOAD_PATH.unshift(dir)
end

%w[json_schemer openapi_first].each do |checkout|
  $LOAD_PATH.unshift(File.join(REFS, checkout, "lib"))
end

begin
  require "openapi_first"
rescue LoadError => error
  abort(format(MISSING_DEPS, error.message, GEM_PATH))
end
