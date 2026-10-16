require "rubocop"

require_relative "rubocop/cop/demo/comment_line_length"
require_relative "rubocop/cop/demo/visitor_missing_super"

RuboCop::ConfigLoader.inject_defaults!(File.expand_path("../config/default.yml", __dir__))
