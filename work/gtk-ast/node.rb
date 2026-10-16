module GirAst
  class Node
    attr_reader :children, :line

    def initialize(children: [], line: nil, **values)
      @children = children
      @line = line
      @values = values

      values.each_key do |field|
        raise ArgumentError, "#{self.class}: unknown field #{field.inspect}" unless self.class::FIELDS.include?(field)
      end
    end

    def definition = self.class::DEFINITION
    def element = self.class::ELEMENT
    def fields = self.class::FIELDS
    def attributes = self.class::ATTRIBUTES
    def allowed_children = self.class::CHILDREN

    alias deconstruct children

    def deconstruct_keys(requested)
      (requested || [:element, :children, *fields]).each_with_object({}) do |key, deconstructed|
        case key
        when :element then deconstructed[:element] = element
        when :children then deconstructed[:children] = children
        when :line then deconstructed[:line] = line
        else deconstructed[key] = @values[key] if fields.include?(key)
        end
      end
    end

    def to_h
      { element: }.merge(@values.compact)
    end

    def each_node(&block)
      block.call(self)
      children.each { |child| child.each_node(&block) }
    end

    def inspect
      shown = @values.compact.map { |field, value| [field, value.inspect].join(": ") }.join(", ")
      [self.class.name.split("::").last, "(", shown, ")"].join
    end
  end

  class Repository < Node
    DEFINITION = "Repository"
    ELEMENT = "core:repository"
    FIELDS = [:version, :identifier_prefixes, :symbol_prefixes].freeze
    ATTRIBUTES = {version: "version", identifier_prefixes: "c:identifier-prefixes", symbol_prefixes: "c:symbol-prefixes"}.freeze
    CHILDREN = {Include: :zeroOrMore, CInclude: :zeroOrMore, Package: :zeroOrMore, Namespace: :zeroOrMore, DocFormat: :zeroOrMore}.freeze
    REQUIRED = [].freeze

    def version = @values[:version]
    def identifier_prefixes = @values[:identifier_prefixes]
    def symbol_prefixes = @values[:symbol_prefixes]
  end

  class Namespace < Node
    DEFINITION = "Namespace"
    ELEMENT = "core:namespace"
    FIELDS = [:name, :version, :identifier_prefixes, :symbol_prefixes, :prefix, :shared_library].freeze
    ATTRIBUTES = {name: "name", version: "version", identifier_prefixes: "c:identifier-prefixes", symbol_prefixes: "c:symbol-prefixes", prefix: "c:prefix", shared_library: "shared-library"}.freeze
    CHILDREN = {Alias: :zeroOrMore, Class: :zeroOrMore, Interface: :zeroOrMore, Record: :zeroOrMore, Enum: :zeroOrMore, Function: :zeroOrMore, FunctionInline: :zeroOrMore, FunctionMacro: :zeroOrMore, Union: :zeroOrMore, BitField: :zeroOrMore, Callback: :zeroOrMore, Constant: :zeroOrMore, Annotation: :zeroOrMore, Boxed: :zeroOrMore, DocSection: :zeroOrMore}.freeze
    REQUIRED = [].freeze

    def name = @values[:name]
    def version = @values[:version]
    def identifier_prefixes = @values[:identifier_prefixes]
    def symbol_prefixes = @values[:symbol_prefixes]
    def prefix = @values[:prefix]
    def shared_library = @values[:shared_library]
  end

  class Annotation < Node
    DEFINITION = "Annotation"
    ELEMENT = "core:attribute"
    FIELDS = [:name, :value].freeze
    ATTRIBUTES = {name: "name", value: "value"}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [:name, :value].freeze

    def name = @values[:name]
    def value = @values[:value]
  end

  class CInclude < Node
    DEFINITION = "CInclude"
    ELEMENT = "c:include"
    FIELDS = [:name].freeze
    ATTRIBUTES = {name: "name"}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [:name].freeze

    def name = @values[:name]
  end

  class DocFormat < Node
    DEFINITION = "DocFormat"
    ELEMENT = "doc:format"
    FIELDS = [:name].freeze
    ATTRIBUTES = {name: "name"}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [:name].freeze

    def name = @values[:name]
  end

  class Include < Node
    DEFINITION = "Include"
    ELEMENT = "core:include"
    FIELDS = [:name, :version].freeze
    ATTRIBUTES = {name: "name", version: "version"}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [:name].freeze

    def name = @values[:name]
    def version = @values[:version]
  end

  class Package < Node
    DEFINITION = "Package"
    ELEMENT = "core:package"
    FIELDS = [:name].freeze
    ATTRIBUTES = {name: "name"}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [:name].freeze

    def name = @values[:name]
  end

  class Alias < Node
    DEFINITION = "Alias"
    ELEMENT = "core:alias"
    FIELDS = [:name, :type, :introspectable, :deprecated, :deprecated_version, :version, :stability].freeze
    ATTRIBUTES = {name: "name", type: "c:type", introspectable: "introspectable", deprecated: "deprecated", deprecated_version: "deprecated-version", version: "version", stability: "stability"}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [:name, :type].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    DEPRECATED_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def type = @values[:type]
    def introspectable = @values[:introspectable]
    def deprecated = @values[:deprecated]
    def deprecated_version = @values[:deprecated_version]
    def version = @values[:version]
    def stability = @values[:stability]
  end

  class Interface < Node
    DEFINITION = "Interface"
    ELEMENT = "core:interface"
    FIELDS = [:name, :type_name, :get_type, :symbol_prefix, :type, :type_struct, :introspectable, :deprecated, :deprecated_version, :version, :stability].freeze
    ATTRIBUTES = {name: "name", type_name: "glib:type-name", get_type: "glib:get-type", symbol_prefix: "c:symbol-prefix", type: "c:type", type_struct: "glib:type-struct", introspectable: "introspectable", deprecated: "deprecated", deprecated_version: "deprecated-version", version: "version", stability: "stability"}.freeze
    CHILDREN = {Prerequisite: :zeroOrMore, Implements: :zeroOrMore, Function: :zeroOrMore, FunctionInline: :zeroOrMore, Constructor: :optional, Method: :zeroOrMore, MethodInline: :zeroOrMore, VirtualMethod: :zeroOrMore, Field: :zeroOrMore, Property: :zeroOrMore, Signal: :zeroOrMore, Callback: :zeroOrMore, Constant: :zeroOrMore}.freeze
    REQUIRED = [:name, :type_name, :get_type].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    DEPRECATED_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def type_name = @values[:type_name]
    def get_type = @values[:get_type]
    def symbol_prefix = @values[:symbol_prefix]
    def type = @values[:type]
    def type_struct = @values[:type_struct]
    def introspectable = @values[:introspectable]
    def deprecated = @values[:deprecated]
    def deprecated_version = @values[:deprecated_version]
    def version = @values[:version]
    def stability = @values[:stability]
  end

  class Class < Node
    DEFINITION = "Class"
    ELEMENT = "core:class"
    FIELDS = [:name, :type_name, :get_type, :parent, :type_struct, :ref_func, :unref_func, :set_value_func, :get_value_func, :type, :symbol_prefix, :abstract, :fundamental, :final, :introspectable, :deprecated, :deprecated_version, :version, :stability].freeze
    ATTRIBUTES = {name: "name", type_name: "glib:type-name", get_type: "glib:get-type", parent: "parent", type_struct: "glib:type-struct", ref_func: "glib:ref-func", unref_func: "glib:unref-func", set_value_func: "glib:set-value-func", get_value_func: "glib:get-value-func", type: "c:type", symbol_prefix: "c:symbol-prefix", abstract: "abstract", fundamental: "glib:fundamental", final: "final", introspectable: "introspectable", deprecated: "deprecated", deprecated_version: "deprecated-version", version: "version", stability: "stability"}.freeze
    CHILDREN = {Implements: :zeroOrMore, Constructor: :zeroOrMore, Method: :zeroOrMore, MethodInline: :zeroOrMore, Function: :zeroOrMore, FunctionInline: :zeroOrMore, VirtualMethod: :zeroOrMore, Field: :zeroOrMore, Property: :zeroOrMore, Signal: :zeroOrMore, Union: :zeroOrMore, Constant: :zeroOrMore, Record: :zeroOrMore, Callback: :zeroOrMore}.freeze
    REQUIRED = [:name, :type_name, :get_type].freeze
    ABSTRACT_DOMAIN = ["0", "1"].freeze
    FUNDAMENTAL_DOMAIN = ["0", "1"].freeze
    FINAL_DOMAIN = ["0", "1"].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    DEPRECATED_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def type_name = @values[:type_name]
    def get_type = @values[:get_type]
    def parent = @values[:parent]
    def type_struct = @values[:type_struct]
    def ref_func = @values[:ref_func]
    def unref_func = @values[:unref_func]
    def set_value_func = @values[:set_value_func]
    def get_value_func = @values[:get_value_func]
    def type = @values[:type]
    def symbol_prefix = @values[:symbol_prefix]
    def abstract = @values[:abstract]
    def fundamental = @values[:fundamental]
    def final = @values[:final]
    def introspectable = @values[:introspectable]
    def deprecated = @values[:deprecated]
    def deprecated_version = @values[:deprecated_version]
    def version = @values[:version]
    def stability = @values[:stability]
  end

  class Boxed < Node
    DEFINITION = "Boxed"
    ELEMENT = "glib:boxed"
    FIELDS = [:name, :symbol_prefix, :type_name, :get_type, :introspectable, :deprecated, :deprecated_version, :version, :stability].freeze
    ATTRIBUTES = {name: "glib:name", symbol_prefix: "c:symbol-prefix", type_name: "glib:type-name", get_type: "glib:get-type", introspectable: "introspectable", deprecated: "deprecated", deprecated_version: "deprecated-version", version: "version", stability: "stability"}.freeze
    CHILDREN = {Function: :zeroOrMore, FunctionInline: :zeroOrMore}.freeze
    REQUIRED = [:name].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    DEPRECATED_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def symbol_prefix = @values[:symbol_prefix]
    def type_name = @values[:type_name]
    def get_type = @values[:get_type]
    def introspectable = @values[:introspectable]
    def deprecated = @values[:deprecated]
    def deprecated_version = @values[:deprecated_version]
    def version = @values[:version]
    def stability = @values[:stability]
  end

  class Record < Node
    DEFINITION = "Record"
    ELEMENT = "core:record"
    FIELDS = [:name, :type, :disguised, :opaque, :pointer, :type_name, :get_type, :symbol_prefix, :foreign, :is_gtype_struct_for, :copy_function, :free_function, :introspectable, :deprecated, :deprecated_version, :version, :stability].freeze
    ATTRIBUTES = {name: "name", type: "c:type", disguised: "disguised", opaque: "opaque", pointer: "pointer", type_name: "glib:type-name", get_type: "glib:get-type", symbol_prefix: "c:symbol-prefix", foreign: "foreign", is_gtype_struct_for: "glib:is-gtype-struct-for", copy_function: "copy-function", free_function: "free-function", introspectable: "introspectable", deprecated: "deprecated", deprecated_version: "deprecated-version", version: "version", stability: "stability"}.freeze
    CHILDREN = {Field: :zeroOrMore, Function: :zeroOrMore, FunctionInline: :zeroOrMore, Union: :zeroOrMore, Method: :zeroOrMore, MethodInline: :zeroOrMore, Constructor: :zeroOrMore}.freeze
    REQUIRED = [:name].freeze
    DISGUISED_DOMAIN = ["0", "1"].freeze
    OPAQUE_DOMAIN = ["0", "1"].freeze
    POINTER_DOMAIN = ["0", "1"].freeze
    FOREIGN_DOMAIN = ["0", "1"].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    DEPRECATED_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def type = @values[:type]
    def disguised = @values[:disguised]
    def opaque = @values[:opaque]
    def pointer = @values[:pointer]
    def type_name = @values[:type_name]
    def get_type = @values[:get_type]
    def symbol_prefix = @values[:symbol_prefix]
    def foreign = @values[:foreign]
    def is_gtype_struct_for = @values[:is_gtype_struct_for]
    def copy_function = @values[:copy_function]
    def free_function = @values[:free_function]
    def introspectable = @values[:introspectable]
    def deprecated = @values[:deprecated]
    def deprecated_version = @values[:deprecated_version]
    def version = @values[:version]
    def stability = @values[:stability]
  end

  class DocElements < Node
    DEFINITION = "DocElements"
    ELEMENT = "core:doc-version"
    FIELDS = [:space, :whitespace].freeze
    ATTRIBUTES = {space: "space", whitespace: "whitespace"}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [].freeze
    SPACE_DOMAIN = ["preserve"].freeze
    WHITESPACE_DOMAIN = ["preserve"].freeze

    def space = @values[:space]
    def whitespace = @values[:whitespace]
  end

  class Constant < Node
    DEFINITION = "Constant"
    ELEMENT = "core:constant"
    FIELDS = [:name, :value, :type, :identifier, :introspectable, :deprecated, :deprecated_version, :version, :stability].freeze
    ATTRIBUTES = {name: "name", value: "value", type: "c:type", identifier: "c:identifier", introspectable: "introspectable", deprecated: "deprecated", deprecated_version: "deprecated-version", version: "version", stability: "stability"}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [:name, :value].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    DEPRECATED_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def value = @values[:value]
    def type = @values[:type]
    def identifier = @values[:identifier]
    def introspectable = @values[:introspectable]
    def deprecated = @values[:deprecated]
    def deprecated_version = @values[:deprecated_version]
    def version = @values[:version]
    def stability = @values[:stability]
  end

  class Property < Node
    DEFINITION = "Property"
    ELEMENT = "core:property"
    FIELDS = [:name, :writable, :readable, :construct, :construct_only, :setter, :getter, :default_value, :introspectable, :deprecated, :deprecated_version, :version, :stability, :transfer_ownership].freeze
    ATTRIBUTES = {name: "name", writable: "writable", readable: "readable", construct: "construct", construct_only: "construct-only", setter: "setter", getter: "getter", default_value: "default-value", introspectable: "introspectable", deprecated: "deprecated", deprecated_version: "deprecated-version", version: "version", stability: "stability", transfer_ownership: "transfer-ownership"}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [:name, :transfer_ownership].freeze
    WRITABLE_DOMAIN = ["0", "1"].freeze
    READABLE_DOMAIN = ["0", "1"].freeze
    CONSTRUCT_DOMAIN = ["0", "1"].freeze
    CONSTRUCT_ONLY_DOMAIN = ["0", "1"].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    DEPRECATED_DOMAIN = ["0", "1"].freeze
    TRANSFER_OWNERSHIP_DOMAIN = ["none", "container", "full"].freeze

    def name = @values[:name]
    def writable = @values[:writable]
    def readable = @values[:readable]
    def construct = @values[:construct]
    def construct_only = @values[:construct_only]
    def setter = @values[:setter]
    def getter = @values[:getter]
    def default_value = @values[:default_value]
    def introspectable = @values[:introspectable]
    def deprecated = @values[:deprecated]
    def deprecated_version = @values[:deprecated_version]
    def version = @values[:version]
    def stability = @values[:stability]
    def transfer_ownership = @values[:transfer_ownership]
  end

  class Signal < Node
    DEFINITION = "Signal"
    ELEMENT = "glib:signal"
    FIELDS = [:name, :detailed, :when, :action, :no_hooks, :no_recurse, :emitter, :introspectable, :deprecated, :deprecated_version, :version, :stability].freeze
    ATTRIBUTES = {name: "name", detailed: "detailed", when: "when", action: "action", no_hooks: "no-hooks", no_recurse: "no-recurse", emitter: "emitter", introspectable: "introspectable", deprecated: "deprecated", deprecated_version: "deprecated-version", version: "version", stability: "stability"}.freeze
    CHILDREN = {CallableParams: :optional, CallableReturn: :optional}.freeze
    REQUIRED = [:name].freeze
    DETAILED_DOMAIN = ["0", "1"].freeze
    WHEN_DOMAIN = ["first", "last", "cleanup"].freeze
    ACTION_DOMAIN = ["0", "1"].freeze
    NO_HOOKS_DOMAIN = ["0", "1"].freeze
    NO_RECURSE_DOMAIN = ["0", "1"].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    DEPRECATED_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def detailed = @values[:detailed]
    def when = @values[:when]
    def action = @values[:action]
    def no_hooks = @values[:no_hooks]
    def no_recurse = @values[:no_recurse]
    def emitter = @values[:emitter]
    def introspectable = @values[:introspectable]
    def deprecated = @values[:deprecated]
    def deprecated_version = @values[:deprecated_version]
    def version = @values[:version]
    def stability = @values[:stability]
  end

  class Field < Node
    DEFINITION = "Field"
    ELEMENT = "core:field"
    FIELDS = [:name, :writable, :readable, :private, :bits, :introspectable, :deprecated, :deprecated_version, :version, :stability].freeze
    ATTRIBUTES = {name: "name", writable: "writable", readable: "readable", private: "private", bits: "bits", introspectable: "introspectable", deprecated: "deprecated", deprecated_version: "deprecated-version", version: "version", stability: "stability"}.freeze
    CHILDREN = {Callback: :once}.freeze
    REQUIRED = [:name].freeze
    WRITABLE_DOMAIN = ["0", "1"].freeze
    READABLE_DOMAIN = ["0", "1"].freeze
    PRIVATE_DOMAIN = ["0", "1"].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    DEPRECATED_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def writable = @values[:writable]
    def readable = @values[:readable]
    def private = @values[:private]
    def bits = @values[:bits]
    def introspectable = @values[:introspectable]
    def deprecated = @values[:deprecated]
    def deprecated_version = @values[:deprecated_version]
    def version = @values[:version]
    def stability = @values[:stability]
  end

  class Callback < Node
    DEFINITION = "Callback"
    ELEMENT = "core:callback"
    FIELDS = [:name, :type, :throws, :introspectable, :deprecated, :deprecated_version, :version, :stability].freeze
    ATTRIBUTES = {name: "name", type: "c:type", throws: "throws", introspectable: "introspectable", deprecated: "deprecated", deprecated_version: "deprecated-version", version: "version", stability: "stability"}.freeze
    CHILDREN = {CallableParams: :optional, CallableReturn: :optional}.freeze
    REQUIRED = [:name].freeze
    THROWS_DOMAIN = ["0", "1"].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    DEPRECATED_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def type = @values[:type]
    def throws = @values[:throws]
    def introspectable = @values[:introspectable]
    def deprecated = @values[:deprecated]
    def deprecated_version = @values[:deprecated_version]
    def version = @values[:version]
    def stability = @values[:stability]
  end

  class Implements < Node
    DEFINITION = "Implements"
    ELEMENT = "core:implements"
    FIELDS = [:name].freeze
    ATTRIBUTES = {name: "name"}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [:name].freeze

    def name = @values[:name]
  end

  class Prerequisite < Node
    DEFINITION = "Prerequisite"
    ELEMENT = "core:prerequisite"
    FIELDS = [:name].freeze
    ATTRIBUTES = {name: "name"}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [:name].freeze

    def name = @values[:name]
  end

  class Type < Node
    DEFINITION = "Type"
    ELEMENT = "core:type"
    FIELDS = [:name, :type, :introspectable].freeze
    ATTRIBUTES = {name: "name", type: "c:type", introspectable: "introspectable"}.freeze
    CHILDREN = {DocElements: :once}.freeze
    REQUIRED = [].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def type = @values[:type]
    def introspectable = @values[:introspectable]
  end

  class ArrayType < Node
    DEFINITION = "ArrayType"
    ELEMENT = "core:array"
    FIELDS = [:name, :zero_terminated, :fixed_size, :introspectable, :length, :type].freeze
    ATTRIBUTES = {name: "name", zero_terminated: "zero-terminated", fixed_size: "fixed-size", introspectable: "introspectable", length: "length", type: "c:type"}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [].freeze
    ZERO_TERMINATED_DOMAIN = ["0", "1"].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def zero_terminated = @values[:zero_terminated]
    def fixed_size = @values[:fixed_size]
    def introspectable = @values[:introspectable]
    def length = @values[:length]
    def type = @values[:type]
  end

  class Constructor < Node
    DEFINITION = "Constructor"
    ELEMENT = "core:constructor"
    FIELDS = [:name, :identifier, :shadowed_by, :shadows, :throws, :moved_to, :async_func, :sync_func, :finish_func].freeze
    ATTRIBUTES = {name: "name", identifier: "c:identifier", shadowed_by: "shadowed-by", shadows: "shadows", throws: "throws", moved_to: "moved-to", async_func: "glib:async-func", sync_func: "glib:sync-func", finish_func: "glib:finish-func"}.freeze
    CHILDREN = {CallableParams: :optional, CallableReturn: :optional}.freeze
    REQUIRED = [:name].freeze
    THROWS_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def identifier = @values[:identifier]
    def shadowed_by = @values[:shadowed_by]
    def shadows = @values[:shadows]
    def throws = @values[:throws]
    def moved_to = @values[:moved_to]
    def async_func = @values[:async_func]
    def sync_func = @values[:sync_func]
    def finish_func = @values[:finish_func]
  end

  class VarArgs < Node
    DEFINITION = "VarArgs"
    ELEMENT = "core:varargs"
    FIELDS = [].freeze
    ATTRIBUTES = {}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [].freeze
  end

  class CallableParams < Node
    DEFINITION = "Callable.params"
    ELEMENT = "core:parameters"
    FIELDS = [].freeze
    ATTRIBUTES = {}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [].freeze
  end

  class CallableReturn < Node
    DEFINITION = "Callable.return"
    ELEMENT = "core:return-value"
    FIELDS = [:introspectable, :nullable, :closure, :scope, :destroy, :skip, :allow_none, :transfer_ownership].freeze
    ATTRIBUTES = {introspectable: "introspectable", nullable: "nullable", closure: "closure", scope: "scope", destroy: "destroy", skip: "skip", allow_none: "allow-none", transfer_ownership: "transfer-ownership"}.freeze
    CHILDREN = {DocElements: :once, Annotation: :zeroOrMore}.freeze
    REQUIRED = [:transfer_ownership].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    NULLABLE_DOMAIN = ["0", "1"].freeze
    SCOPE_DOMAIN = ["notified", "async", "call", "forever"].freeze
    SKIP_DOMAIN = ["0", "1"].freeze
    ALLOW_NONE_DOMAIN = ["0", "1"].freeze
    TRANSFER_OWNERSHIP_DOMAIN = ["none", "container", "full"].freeze

    def introspectable = @values[:introspectable]
    def nullable = @values[:nullable]
    def closure = @values[:closure]
    def scope = @values[:scope]
    def destroy = @values[:destroy]
    def skip = @values[:skip]
    def allow_none = @values[:allow_none]
    def transfer_ownership = @values[:transfer_ownership]
  end

  class Function < Node
    DEFINITION = "Function"
    ELEMENT = "core:function"
    FIELDS = [:name, :identifier, :shadowed_by, :shadows, :throws, :moved_to, :async_func, :sync_func, :finish_func].freeze
    ATTRIBUTES = {name: "name", identifier: "c:identifier", shadowed_by: "shadowed-by", shadows: "shadows", throws: "throws", moved_to: "moved-to", async_func: "glib:async-func", sync_func: "glib:sync-func", finish_func: "glib:finish-func"}.freeze
    CHILDREN = {CallableParams: :optional, CallableReturn: :optional}.freeze
    REQUIRED = [:name].freeze
    THROWS_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def identifier = @values[:identifier]
    def shadowed_by = @values[:shadowed_by]
    def shadows = @values[:shadows]
    def throws = @values[:throws]
    def moved_to = @values[:moved_to]
    def async_func = @values[:async_func]
    def sync_func = @values[:sync_func]
    def finish_func = @values[:finish_func]
  end

  class FunctionInline < Node
    DEFINITION = "FunctionInline"
    ELEMENT = "core:function-inline"
    FIELDS = [:name, :identifier, :shadowed_by, :shadows, :throws, :moved_to, :async_func, :sync_func, :finish_func].freeze
    ATTRIBUTES = {name: "name", identifier: "c:identifier", shadowed_by: "shadowed-by", shadows: "shadows", throws: "throws", moved_to: "moved-to", async_func: "glib:async-func", sync_func: "glib:sync-func", finish_func: "glib:finish-func"}.freeze
    CHILDREN = {CallableParams: :optional, CallableReturn: :optional, DocElements: :once}.freeze
    REQUIRED = [:name].freeze
    THROWS_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def identifier = @values[:identifier]
    def shadowed_by = @values[:shadowed_by]
    def shadows = @values[:shadows]
    def throws = @values[:throws]
    def moved_to = @values[:moved_to]
    def async_func = @values[:async_func]
    def sync_func = @values[:sync_func]
    def finish_func = @values[:finish_func]
  end

  class FunctionMacro < Node
    DEFINITION = "FunctionMacro"
    ELEMENT = "core:function-macro"
    FIELDS = [:name, :identifier, :shadowed_by, :shadows, :throws, :moved_to, :async_func, :sync_func, :finish_func].freeze
    ATTRIBUTES = {name: "name", identifier: "c:identifier", shadowed_by: "shadowed-by", shadows: "shadows", throws: "throws", moved_to: "moved-to", async_func: "glib:async-func", sync_func: "glib:sync-func", finish_func: "glib:finish-func"}.freeze
    CHILDREN = {CallableParams: :optional}.freeze
    REQUIRED = [:name].freeze
    THROWS_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def identifier = @values[:identifier]
    def shadowed_by = @values[:shadowed_by]
    def shadows = @values[:shadows]
    def throws = @values[:throws]
    def moved_to = @values[:moved_to]
    def async_func = @values[:async_func]
    def sync_func = @values[:sync_func]
    def finish_func = @values[:finish_func]
  end

  class Method < Node
    DEFINITION = "Method"
    ELEMENT = "core:method"
    FIELDS = [:set_property, :get_property, :name, :identifier, :shadowed_by, :shadows, :throws, :moved_to, :async_func, :sync_func, :finish_func].freeze
    ATTRIBUTES = {set_property: "glib:set-property", get_property: "glib:get-property", name: "name", identifier: "c:identifier", shadowed_by: "shadowed-by", shadows: "shadows", throws: "throws", moved_to: "moved-to", async_func: "glib:async-func", sync_func: "glib:sync-func", finish_func: "glib:finish-func"}.freeze
    CHILDREN = {CallableParams: :optional, CallableReturn: :optional}.freeze
    REQUIRED = [:name].freeze
    THROWS_DOMAIN = ["0", "1"].freeze

    def set_property = @values[:set_property]
    def get_property = @values[:get_property]
    def name = @values[:name]
    def identifier = @values[:identifier]
    def shadowed_by = @values[:shadowed_by]
    def shadows = @values[:shadows]
    def throws = @values[:throws]
    def moved_to = @values[:moved_to]
    def async_func = @values[:async_func]
    def sync_func = @values[:sync_func]
    def finish_func = @values[:finish_func]
  end

  class MethodInline < Node
    DEFINITION = "MethodInline"
    ELEMENT = "core:method-inline"
    FIELDS = [:name, :identifier, :shadowed_by, :shadows, :throws, :moved_to, :async_func, :sync_func, :finish_func].freeze
    ATTRIBUTES = {name: "name", identifier: "c:identifier", shadowed_by: "shadowed-by", shadows: "shadows", throws: "throws", moved_to: "moved-to", async_func: "glib:async-func", sync_func: "glib:sync-func", finish_func: "glib:finish-func"}.freeze
    CHILDREN = {CallableParams: :optional, CallableReturn: :optional}.freeze
    REQUIRED = [:name].freeze
    THROWS_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def identifier = @values[:identifier]
    def shadowed_by = @values[:shadowed_by]
    def shadows = @values[:shadows]
    def throws = @values[:throws]
    def moved_to = @values[:moved_to]
    def async_func = @values[:async_func]
    def sync_func = @values[:sync_func]
    def finish_func = @values[:finish_func]
  end

  class VirtualMethod < Node
    DEFINITION = "VirtualMethod"
    ELEMENT = "core:virtual-method"
    FIELDS = [:invoker, :name, :identifier, :shadowed_by, :shadows, :throws, :moved_to, :async_func, :sync_func, :finish_func].freeze
    ATTRIBUTES = {invoker: "invoker", name: "name", identifier: "c:identifier", shadowed_by: "shadowed-by", shadows: "shadows", throws: "throws", moved_to: "moved-to", async_func: "glib:async-func", sync_func: "glib:sync-func", finish_func: "glib:finish-func"}.freeze
    CHILDREN = {CallableParams: :optional, CallableReturn: :optional}.freeze
    REQUIRED = [:name].freeze
    THROWS_DOMAIN = ["0", "1"].freeze

    def invoker = @values[:invoker]
    def name = @values[:name]
    def identifier = @values[:identifier]
    def shadowed_by = @values[:shadowed_by]
    def shadows = @values[:shadows]
    def throws = @values[:throws]
    def moved_to = @values[:moved_to]
    def async_func = @values[:async_func]
    def sync_func = @values[:sync_func]
    def finish_func = @values[:finish_func]
  end

  class Union < Node
    DEFINITION = "Union"
    ELEMENT = "core:union"
    FIELDS = [:name, :type, :symbol_prefix, :type_name, :get_type, :copy_function, :free_function, :introspectable, :deprecated, :deprecated_version, :version, :stability].freeze
    ATTRIBUTES = {name: "name", type: "c:type", symbol_prefix: "c:symbol-prefix", type_name: "glib:type-name", get_type: "glib:get-type", copy_function: "copy-function", free_function: "free-function", introspectable: "introspectable", deprecated: "deprecated", deprecated_version: "deprecated-version", version: "version", stability: "stability"}.freeze
    CHILDREN = {Field: :zeroOrMore, Constructor: :zeroOrMore, Method: :zeroOrMore, MethodInline: :zeroOrMore, Function: :zeroOrMore, FunctionInline: :zeroOrMore, Record: :zeroOrMore}.freeze
    REQUIRED = [].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    DEPRECATED_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def type = @values[:type]
    def symbol_prefix = @values[:symbol_prefix]
    def type_name = @values[:type_name]
    def get_type = @values[:get_type]
    def copy_function = @values[:copy_function]
    def free_function = @values[:free_function]
    def introspectable = @values[:introspectable]
    def deprecated = @values[:deprecated]
    def deprecated_version = @values[:deprecated_version]
    def version = @values[:version]
    def stability = @values[:stability]
  end

  class BitField < Node
    DEFINITION = "BitField"
    ELEMENT = "core:bitfield"
    FIELDS = [:name, :type, :type_name, :get_type, :introspectable, :deprecated, :deprecated_version, :version, :stability].freeze
    ATTRIBUTES = {name: "name", type: "c:type", type_name: "glib:type-name", get_type: "glib:get-type", introspectable: "introspectable", deprecated: "deprecated", deprecated_version: "deprecated-version", version: "version", stability: "stability"}.freeze
    CHILDREN = {Member: :zeroOrMore, Function: :zeroOrMore, FunctionInline: :zeroOrMore}.freeze
    REQUIRED = [:name, :type].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    DEPRECATED_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def type = @values[:type]
    def type_name = @values[:type_name]
    def get_type = @values[:get_type]
    def introspectable = @values[:introspectable]
    def deprecated = @values[:deprecated]
    def deprecated_version = @values[:deprecated_version]
    def version = @values[:version]
    def stability = @values[:stability]
  end

  class Enum < Node
    DEFINITION = "Enum"
    ELEMENT = "core:enumeration"
    FIELDS = [:name, :type, :type_name, :get_type, :error_domain, :introspectable, :deprecated, :deprecated_version, :version, :stability].freeze
    ATTRIBUTES = {name: "name", type: "c:type", type_name: "glib:type-name", get_type: "glib:get-type", error_domain: "glib:error-domain", introspectable: "introspectable", deprecated: "deprecated", deprecated_version: "deprecated-version", version: "version", stability: "stability"}.freeze
    CHILDREN = {Member: :zeroOrMore, Function: :zeroOrMore, FunctionInline: :zeroOrMore}.freeze
    REQUIRED = [:name, :type].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    DEPRECATED_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def type = @values[:type]
    def type_name = @values[:type_name]
    def get_type = @values[:get_type]
    def error_domain = @values[:error_domain]
    def introspectable = @values[:introspectable]
    def deprecated = @values[:deprecated]
    def deprecated_version = @values[:deprecated_version]
    def version = @values[:version]
    def stability = @values[:stability]
  end

  class Member < Node
    DEFINITION = "Member"
    ELEMENT = "core:member"
    FIELDS = [:name, :value, :identifier, :nick, :introspectable, :deprecated, :deprecated_version, :version, :stability].freeze
    ATTRIBUTES = {name: "name", value: "value", identifier: "c:identifier", nick: "glib:nick", introspectable: "introspectable", deprecated: "deprecated", deprecated_version: "deprecated-version", version: "version", stability: "stability"}.freeze
    CHILDREN = {}.freeze
    REQUIRED = [:name, :value, :identifier].freeze
    INTROSPECTABLE_DOMAIN = ["0", "1"].freeze
    DEPRECATED_DOMAIN = ["0", "1"].freeze

    def name = @values[:name]
    def value = @values[:value]
    def identifier = @values[:identifier]
    def nick = @values[:nick]
    def introspectable = @values[:introspectable]
    def deprecated = @values[:deprecated]
    def deprecated_version = @values[:deprecated_version]
    def version = @values[:version]
    def stability = @values[:stability]
  end

  class DocSection < Node
    DEFINITION = "DocSection"
    ELEMENT = "core:docsection"
    FIELDS = [:name].freeze
    ATTRIBUTES = {name: "name"}.freeze
    CHILDREN = {DocElements: :once}.freeze
    REQUIRED = [:name].freeze

    def name = @values[:name]
  end

  BY_ELEMENT = {
    "repository" => Repository,
    "namespace" => Namespace,
    "attribute" => Annotation,
    "c:include" => CInclude,
    "doc:format" => DocFormat,
    "include" => Include,
    "package" => Package,
    "alias" => Alias,
    "interface" => Interface,
    "class" => Class,
    "glib:boxed" => Boxed,
    "record" => Record,
    "doc-version" => DocElements,
    "constant" => Constant,
    "property" => Property,
    "glib:signal" => Signal,
    "field" => Field,
    "callback" => Callback,
    "implements" => Implements,
    "prerequisite" => Prerequisite,
    "type" => Type,
    "array" => ArrayType,
    "constructor" => Constructor,
    "varargs" => VarArgs,
    "parameters" => CallableParams,
    "return-value" => CallableReturn,
    "function" => Function,
    "function-inline" => FunctionInline,
    "function-macro" => FunctionMacro,
    "method" => Method,
    "method-inline" => MethodInline,
    "virtual-method" => VirtualMethod,
    "union" => Union,
    "bitfield" => BitField,
    "enumeration" => Enum,
    "member" => Member,
    "docsection" => DocSection,
  }.freeze

  BY_DEFINITION = {
    "Repository" => Repository,
    "Namespace" => Namespace,
    "Annotation" => Annotation,
    "CInclude" => CInclude,
    "DocFormat" => DocFormat,
    "Include" => Include,
    "Package" => Package,
    "Alias" => Alias,
    "Interface" => Interface,
    "Class" => Class,
    "Boxed" => Boxed,
    "Record" => Record,
    "DocElements" => DocElements,
    "Constant" => Constant,
    "Property" => Property,
    "Signal" => Signal,
    "Field" => Field,
    "Callback" => Callback,
    "Implements" => Implements,
    "Prerequisite" => Prerequisite,
    "Type" => Type,
    "ArrayType" => ArrayType,
    "Constructor" => Constructor,
    "VarArgs" => VarArgs,
    "Callable.params" => CallableParams,
    "Callable.return" => CallableReturn,
    "Function" => Function,
    "FunctionInline" => FunctionInline,
    "FunctionMacro" => FunctionMacro,
    "Method" => Method,
    "MethodInline" => MethodInline,
    "VirtualMethod" => VirtualMethod,
    "Union" => Union,
    "BitField" => BitField,
    "Enum" => Enum,
    "Member" => Member,
    "DocSection" => DocSection,
  }.freeze
end
