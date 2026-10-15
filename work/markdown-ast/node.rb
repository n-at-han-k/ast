module MarkdownTypes
  TYPES = {}
  BY_TYPE = {}

  class Node
    attr_reader :line, :end_line, :children

    def initialize(line:, end_line:, children:)
      @line = line
      @end_line = end_line
      @children = children
    end

    def type = self.class::TYPE
    def fields = self.class::FIELDS
    def kind = self.class::KIND

    alias deconstruct children

    def deconstruct_keys(keys)
      (keys || self.class::KEYS).each_with_object({}) do |key, deconstructed|
        deconstructed[key] = public_send(key) if self.class::KEYS.include?(key)
      end
    end

    def text
      children.map(&:text).join
    end

    def name = self.class.name.split("::").last

    def inspect
      shown = fields.map { |field| [field, public_send(field).inspect].join(": ") }.join(", ")
      [name, "(", shown, ")"].join
    end
  end

  class Alert < Node
    TYPE = :alert
    FIELDS = [:alert_type].freeze
    KEYS = [:type, :line, :end_line, :children, :alert_type].freeze
    KIND = ["Paragraph"].freeze
    ALERT_TYPE_DOMAIN = [:note].freeze

    attr_reader :alert_type

    def initialize(line:, end_line:, children:, alert_type:)
      super(line:, end_line:, children:)
      @alert_type = alert_type
    end
  end

  TYPES[:alert] = [:alert_type].freeze
  BY_TYPE[:alert] = Alert

  class BlockQuote < Node
    TYPE = :block_quote
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["BlockQuote", "CodeBlock", "Heading", "HtmlBlock", "List", "Paragraph"].freeze
    SPEC_KIND = ["BlockQuote", "CodeBlock", "CustomBlock", "Heading", "HtmlBlock", "List", "Paragraph", "ThematicBreak"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:block_quote] = [].freeze
  BY_TYPE[:block_quote] = BlockQuote

  class Code < Node
    TYPE = :code
    FIELDS = [:literal].freeze
    KEYS = [:type, :line, :end_line, :children, :literal].freeze
    KIND = [].freeze

    attr_reader :literal

    def initialize(line:, end_line:, children:, literal:)
      super(line:, end_line:, children:)
      @literal = literal
    end

    alias string_content literal

    def text = literal.to_s
  end

  TYPES[:code] = [:literal].freeze
  BY_TYPE[:code] = Code

  class CodeBlock < Node
    TYPE = :code_block
    FIELDS = [:fence_info, :fenced?, :literal].freeze
    KEYS = [:type, :line, :end_line, :children, :fence_info, :fenced?, :literal].freeze
    KIND = [].freeze

    attr_reader :fence_info, :fenced, :literal

    def initialize(line:, end_line:, children:, fence_info:, fenced:, literal:)
      super(line:, end_line:, children:)
      @fence_info = fence_info
      @fenced = fenced
      @literal = literal
    end

    alias string_content literal

    alias fenced? fenced

    def text = literal.to_s
  end

  TYPES[:code_block] = [:fence_info, :fenced?, :literal].freeze
  BY_TYPE[:code_block] = CodeBlock

  class DescriptionDetails < Node
    TYPE = :description_details
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Paragraph"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:description_details] = [].freeze
  BY_TYPE[:description_details] = DescriptionDetails

  class DescriptionItem < Node
    TYPE = :description_item
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["DescriptionDetails", "DescriptionTerm"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:description_item] = [].freeze
  BY_TYPE[:description_item] = DescriptionItem

  class DescriptionList < Node
    TYPE = :description_list
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["DescriptionItem"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:description_list] = [].freeze
  BY_TYPE[:description_list] = DescriptionList

  class DescriptionTerm < Node
    TYPE = :description_term
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Paragraph"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:description_term] = [].freeze
  BY_TYPE[:description_term] = DescriptionTerm

  class Document < Node
    TYPE = :document
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Alert", "BlockQuote", "CodeBlock", "DescriptionList", "FootnoteDefinition", "Frontmatter", "Heading", "HtmlBlock", "List", "MultilineBlockQuote", "Paragraph", "Table", "ThematicBreak"].freeze
    SPEC_KIND = ["BlockQuote", "CodeBlock", "CustomBlock", "Heading", "HtmlBlock", "List", "Paragraph", "ThematicBreak"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:document] = [].freeze
  BY_TYPE[:document] = Document

  class Emph < Node
    TYPE = :emph
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Code", "Emph", "Escaped", "Linebreak", "Link", "Softbreak", "Strong", "Text", "Underline"].freeze
    SPEC_KIND = ["Code", "CustomInline", "Emph", "HtmlInline", "Image", "Linebreak", "Link", "Softbreak", "Strong", "Text"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:emph] = [].freeze
  BY_TYPE[:emph] = Emph

  class Escaped < Node
    TYPE = :escaped
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Text"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:escaped] = [].freeze
  BY_TYPE[:escaped] = Escaped

  class FootnoteDefinition < Node
    TYPE = :footnote_definition
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Paragraph"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:footnote_definition] = [].freeze
  BY_TYPE[:footnote_definition] = FootnoteDefinition

  class FootnoteReference < Node
    TYPE = :footnote_reference
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = [].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:footnote_reference] = [].freeze
  BY_TYPE[:footnote_reference] = FootnoteReference

  class Frontmatter < Node
    TYPE = :frontmatter
    FIELDS = [:literal].freeze
    KEYS = [:type, :line, :end_line, :children, :literal].freeze
    KIND = [].freeze

    attr_reader :literal

    def initialize(line:, end_line:, children:, literal:)
      super(line:, end_line:, children:)
      @literal = literal
    end

    alias string_content literal

    def text = literal.to_s
  end

  TYPES[:frontmatter] = [:literal].freeze
  BY_TYPE[:frontmatter] = Frontmatter

  class Heading < Node
    TYPE = :heading
    FIELDS = [:header_level].freeze
    KEYS = [:type, :line, :end_line, :children, :header_level].freeze
    KIND = ["Emph", "Escaped", "Link", "Softbreak", "Text"].freeze
    SPEC_KIND = ["Code", "CustomInline", "Emph", "HtmlInline", "Image", "Linebreak", "Link", "Softbreak", "Strong", "Text"].freeze
    HEADER_LEVEL_DOMAIN = [1, 2, 3, 4, 5, 6].freeze

    attr_reader :header_level

    def initialize(line:, end_line:, children:, header_level:)
      super(line:, end_line:, children:)
      @header_level = header_level
    end
  end

  TYPES[:heading] = [:header_level].freeze
  BY_TYPE[:heading] = Heading

  class Highlight < Node
    TYPE = :highlight
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Text"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:highlight] = [].freeze
  BY_TYPE[:highlight] = Highlight

  class HtmlBlock < Node
    TYPE = :html_block
    FIELDS = [:literal].freeze
    KEYS = [:type, :line, :end_line, :children, :literal].freeze
    KIND = [].freeze

    attr_reader :literal

    def initialize(line:, end_line:, children:, literal:)
      super(line:, end_line:, children:)
      @literal = literal
    end

    alias string_content literal

    def text = literal.to_s
  end

  TYPES[:html_block] = [:literal].freeze
  BY_TYPE[:html_block] = HtmlBlock

  class HtmlInline < Node
    TYPE = :html_inline
    FIELDS = [:literal].freeze
    KEYS = [:type, :line, :end_line, :children, :literal].freeze
    KIND = [].freeze

    attr_reader :literal

    def initialize(line:, end_line:, children:, literal:)
      super(line:, end_line:, children:)
      @literal = literal
    end

    alias string_content literal

    def text = literal.to_s
  end

  TYPES[:html_inline] = [:literal].freeze
  BY_TYPE[:html_inline] = HtmlInline

  class Image < Node
    TYPE = :image
    FIELDS = [:title, :url].freeze
    KEYS = [:type, :line, :end_line, :children, :title, :url].freeze
    KIND = ["Emph", "Image", "Link", "Text"].freeze
    SPEC_KIND = ["Code", "CustomInline", "Emph", "HtmlInline", "Image", "Linebreak", "Link", "Softbreak", "Strong", "Text"].freeze

    attr_reader :title, :url

    def initialize(line:, end_line:, children:, title:, url:)
      super(line:, end_line:, children:)
      @title = title
      @url = url
    end
  end

  TYPES[:image] = [:title, :url].freeze
  BY_TYPE[:image] = Image

  class Insert < Node
    TYPE = :insert
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Text"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:insert] = [].freeze
  BY_TYPE[:insert] = Insert

  class Item < Node
    TYPE = :item
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["BlockQuote", "CodeBlock", "Heading", "HtmlBlock", "List", "Paragraph", "ThematicBreak"].freeze
    SPEC_KIND = ["BlockQuote", "CodeBlock", "CustomBlock", "Heading", "HtmlBlock", "List", "Paragraph", "ThematicBreak"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:item] = [].freeze
  BY_TYPE[:item] = Item

  class Linebreak < Node
    TYPE = :linebreak
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = [].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end

    def text = " "
  end

  TYPES[:linebreak] = [].freeze
  BY_TYPE[:linebreak] = Linebreak

  class Link < Node
    TYPE = :link
    FIELDS = [:title, :url].freeze
    KEYS = [:type, :line, :end_line, :children, :title, :url].freeze
    KIND = ["Emph", "Escaped", "Image", "Text"].freeze
    SPEC_KIND = ["Code", "CustomInline", "Emph", "HtmlInline", "Image", "Linebreak", "Link", "Softbreak", "Strong", "Text"].freeze

    attr_reader :title, :url

    def initialize(line:, end_line:, children:, title:, url:)
      super(line:, end_line:, children:)
      @title = title
      @url = url
    end
  end

  TYPES[:link] = [:title, :url].freeze
  BY_TYPE[:link] = Link

  class List < Node
    TYPE = :list
    FIELDS = [:list_start, :list_tight, :list_type].freeze
    KEYS = [:type, :line, :end_line, :children, :list_start, :list_tight, :list_type].freeze
    KIND = ["Item", "Taskitem"].freeze
    SPEC_KIND = ["Item"].freeze
    UNAVAILABLE = ["delimiter"].freeze
    LIST_TIGHT_DOMAIN = [true, false].freeze
    LIST_TYPE_DOMAIN = [:bullet, :ordered].freeze

    attr_reader :list_start, :list_tight, :list_type

    def initialize(line:, end_line:, children:, list_start:, list_tight:, list_type:)
      super(line:, end_line:, children:)
      @list_start = list_start
      @list_tight = list_tight
      @list_type = list_type
    end
  end

  TYPES[:list] = [:list_start, :list_tight, :list_type].freeze
  BY_TYPE[:list] = List

  class Math < Node
    TYPE = :math
    FIELDS = [:literal].freeze
    KEYS = [:type, :line, :end_line, :children, :literal].freeze
    KIND = [].freeze

    attr_reader :literal

    def initialize(line:, end_line:, children:, literal:)
      super(line:, end_line:, children:)
      @literal = literal
    end

    alias string_content literal

    def text = literal.to_s
  end

  TYPES[:math] = [:literal].freeze
  BY_TYPE[:math] = Math

  class MultilineBlockQuote < Node
    TYPE = :multiline_block_quote
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Paragraph"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:multiline_block_quote] = [].freeze
  BY_TYPE[:multiline_block_quote] = MultilineBlockQuote

  class Paragraph < Node
    TYPE = :paragraph
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Code", "Emph", "Escaped", "FootnoteReference", "Highlight", "HtmlInline", "Image", "Insert", "Linebreak", "Link", "Math", "Shortcode", "Softbreak", "Spoiler", "Strikethrough", "Strong", "Subscript", "Superscript", "Text", "Underline", "Wikilink"].freeze
    SPEC_KIND = ["Code", "CustomInline", "Emph", "HtmlInline", "Image", "Linebreak", "Link", "Softbreak", "Strong", "Text"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:paragraph] = [].freeze
  BY_TYPE[:paragraph] = Paragraph

  class Shortcode < Node
    TYPE = :shortcode
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = [].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:shortcode] = [].freeze
  BY_TYPE[:shortcode] = Shortcode

  class Softbreak < Node
    TYPE = :softbreak
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = [].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end

    def text = " "
  end

  TYPES[:softbreak] = [].freeze
  BY_TYPE[:softbreak] = Softbreak

  class Spoiler < Node
    TYPE = :spoiler
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Text"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:spoiler] = [].freeze
  BY_TYPE[:spoiler] = Spoiler

  class Strikethrough < Node
    TYPE = :strikethrough
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Text"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:strikethrough] = [].freeze
  BY_TYPE[:strikethrough] = Strikethrough

  class Strong < Node
    TYPE = :strong
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Emph", "Escaped", "Link", "Softbreak", "Strong", "Text"].freeze
    SPEC_KIND = ["Code", "CustomInline", "Emph", "HtmlInline", "Image", "Linebreak", "Link", "Softbreak", "Strong", "Text"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:strong] = [].freeze
  BY_TYPE[:strong] = Strong

  class Subscript < Node
    TYPE = :subscript
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Text"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:subscript] = [].freeze
  BY_TYPE[:subscript] = Subscript

  class Superscript < Node
    TYPE = :superscript
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Text"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:superscript] = [].freeze
  BY_TYPE[:superscript] = Superscript

  class Table < Node
    TYPE = :table
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["TableRow"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:table] = [].freeze
  BY_TYPE[:table] = Table

  class TableCell < Node
    TYPE = :table_cell
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Code", "Strong", "Text"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:table_cell] = [].freeze
  BY_TYPE[:table_cell] = TableCell

  class TableRow < Node
    TYPE = :table_row
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["TableCell"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:table_row] = [].freeze
  BY_TYPE[:table_row] = TableRow

  class Taskitem < Node
    TYPE = :taskitem
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["List", "Paragraph"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:taskitem] = [].freeze
  BY_TYPE[:taskitem] = Taskitem

  class Text < Node
    TYPE = :text
    FIELDS = [:literal].freeze
    KEYS = [:type, :line, :end_line, :children, :literal].freeze
    KIND = [].freeze

    attr_reader :literal

    def initialize(line:, end_line:, children:, literal:)
      super(line:, end_line:, children:)
      @literal = literal
    end

    alias string_content literal

    def text = literal.to_s
  end

  TYPES[:text] = [:literal].freeze
  BY_TYPE[:text] = Text

  class ThematicBreak < Node
    TYPE = :thematic_break
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = [].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:thematic_break] = [].freeze
  BY_TYPE[:thematic_break] = ThematicBreak

  class Underline < Node
    TYPE = :underline
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Emph", "Escaped", "Text", "Underline"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:underline] = [].freeze
  BY_TYPE[:underline] = Underline

  class Wikilink < Node
    TYPE = :wikilink
    FIELDS = [].freeze
    KEYS = [:type, :line, :end_line, :children].freeze
    KIND = ["Text"].freeze

    def initialize(line:, end_line:, children:)
      super(line:, end_line:, children:)
    end
  end

  TYPES[:wikilink] = [].freeze
  BY_TYPE[:wikilink] = Wikilink

  TYPES.freeze
  BY_TYPE.freeze
end
