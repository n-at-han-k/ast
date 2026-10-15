module GtkAst
  class Node
    KEYS = %i[type children].freeze
    FIELDS = [].freeze
    PROPERTIES = {}.freeze

    attr_reader :children

    def initialize(children: [], **values)
      @children = children

      values.each do |field, value|
        raise ArgumentError, "#{self.class}: unknown field #{field.inspect}" unless self.class::KEYS.include?(field)

        instance_variable_set(:"@#{field}", value)
      end
    end

    def type = self.class::TYPE
    def gtype = self.class::GTYPE
    def fields = self.class::FIELDS
    def properties = self.class::PROPERTIES
    def keys = self.class::KEYS

    alias deconstruct children

    def deconstruct_keys(requested)
      (requested || [:type, :children, *keys]).each_with_object({}) do |key, deconstructed|
        case key
        when :type then deconstructed[:type] = type
        when :children then deconstructed[:children] = children
        else deconstructed[key] = public_send(key) if keys.include?(key)
        end
      end
    end

    def to_h
      keys.to_h { |key| [key, public_send(key)] }
    end

    def inspect
      shown = keys.filter_map do |field|
        value = public_send(field)
        [field, value.inspect].join(": ") unless value.nil?
      end
      [self.class.name.split("::").last, "(", shown.join(", "), ")"].join
    end
  end
  module Adw; end
  module GObject; end
  module Gdk; end
  module GdkPixbuf; end
  module Gio; end
  module Gsk; end
  module Gtk; end
  module Pango; end
  module PangoCairo; end

  module GObject
    class Object < GtkAst::Node

      TYPE = "GObject.Object"
      GTYPE = "GObject"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class InitiallyUnowned < Object

      TYPE = "GObject.InitiallyUnowned"
      GTYPE = "GInitiallyUnowned"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    module Accessible

      TYPE = "Gtk.Accessible"
      GTYPE = "GtkAccessible"
      FIELDS = [:accessible_role].freeze
      PROPERTIES = {accessible_role: "accessible-role"}.freeze
      KEYS = FIELDS.dup.freeze
      ACCESSIBLE_ROLE_DOMAIN = [:alert, :alert_dialog, :banner, :button, :caption, :cell, :checkbox, :column_header, :combo_box, :command, :composite, :dialog, :document, :feed, :form, :generic, :grid, :grid_cell, :group, :heading, :img, :input, :label, :landmark, :legend, :link, :list, :list_box, :list_item, :log, :main, :marquee, :math, :meter, :menu, :menu_bar, :menu_item, :menu_item_checkbox, :menu_item_radio, :navigation, :none, :note, :option, :presentation, :progress_bar, :radio, :radio_group, :range, :region, :row, :row_group, :row_header, :scrollbar, :search, :search_box, :section, :section_head, :select, :separator, :slider, :spin_button, :status, :structure, :switch, :tab, :table, :tab_list, :tab_panel, :text_box, :time, :timer, :toolbar, :tooltip, :tree, :tree_grid, :tree_item, :widget, :window, :toggle_button, :application, :paragraph, :block_quote, :article, :comment, :terminal].freeze

      attr_reader :accessible_role
    end
  end

  module Gtk
    module Buildable

      TYPE = "Gtk.Buildable"
      GTYPE = "GtkBuildable"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gtk
    module ConstraintTarget

      TYPE = "Gtk.ConstraintTarget"
      GTYPE = "GtkConstraintTarget"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gtk
    class Widget < GtkAst::GObject::InitiallyUnowned
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Widget"
      GTYPE = "GtkWidget"
      FIELDS = [:can_focus, :can_target, :css_classes, :css_name, :cursor, :focus_on_click, :focusable, :halign, :has_default, :has_focus, :has_tooltip, :height_request, :hexpand, :hexpand_set, :layout_manager, :limit_events, :margin_bottom, :margin_end, :margin_start, :margin_top, :name, :opacity, :overflow, :parent, :receives_default, :root, :scale_factor, :sensitive, :tooltip_markup, :tooltip_text, :valign, :vexpand, :vexpand_set, :visible, :width_request].freeze
      PROPERTIES = {can_focus: "can-focus", can_target: "can-target", css_classes: "css-classes", css_name: "css-name", cursor: "cursor", focus_on_click: "focus-on-click", focusable: "focusable", halign: "halign", has_default: "has-default", has_focus: "has-focus", has_tooltip: "has-tooltip", height_request: "height-request", hexpand: "hexpand", hexpand_set: "hexpand-set", layout_manager: "layout-manager", limit_events: "limit-events", margin_bottom: "margin-bottom", margin_end: "margin-end", margin_start: "margin-start", margin_top: "margin-top", name: "name", opacity: "opacity", overflow: "overflow", parent: "parent", receives_default: "receives-default", root: "root", scale_factor: "scale-factor", sensitive: "sensitive", tooltip_markup: "tooltip-markup", tooltip_text: "tooltip-text", valign: "valign", vexpand: "vexpand", vexpand_set: "vexpand-set", visible: "visible", width_request: "width-request"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      HALIGN_DOMAIN = [:fill, :start, :end, :center, :baseline_fill, :baseline, :baseline_center].freeze
      OVERFLOW_DOMAIN = [:visible, :hidden].freeze
      VALIGN_DOMAIN = [:fill, :start, :end, :center, :baseline_fill, :baseline, :baseline_center].freeze

      attr_reader :can_focus, :can_target, :css_classes, :css_name, :cursor, :focus_on_click, :focusable, :halign, :has_default, :has_focus, :has_tooltip, :height_request, :hexpand, :hexpand_set, :layout_manager, :limit_events, :margin_bottom, :margin_end, :margin_start, :margin_top, :name, :opacity, :overflow, :parent, :receives_default, :root, :scale_factor, :sensitive, :tooltip_markup, :tooltip_text, :valign, :vexpand, :vexpand_set, :visible, :width_request
    end
  end

  module Adw
    module Swipeable

      TYPE = "Adw.Swipeable"
      GTYPE = "AdwSwipeable"
      PREREQUISITES = ["Gtk.Widget"].freeze
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module GObject
    module TypePlugin

      TYPE = "GObject.TypePlugin"
      GTYPE = "GTypePlugin"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gdk
    class Device < GtkAst::GObject::Object

      TYPE = "Gdk.Device"
      GTYPE = "GdkDevice"
      FIELDS = [:active_layout_index, :caps_lock_state, :direction, :display, :has_bidi_layouts, :has_cursor, :layout_names, :modifier_state, :n_axes, :name, :num_lock_state, :num_touches, :product_id, :scroll_lock_state, :seat, :source, :tool, :vendor_id].freeze
      PROPERTIES = {active_layout_index: "active-layout-index", caps_lock_state: "caps-lock-state", direction: "direction", display: "display", has_bidi_layouts: "has-bidi-layouts", has_cursor: "has-cursor", layout_names: "layout-names", modifier_state: "modifier-state", n_axes: "n-axes", name: "name", num_lock_state: "num-lock-state", num_touches: "num-touches", product_id: "product-id", scroll_lock_state: "scroll-lock-state", seat: "seat", source: "source", tool: "tool", vendor_id: "vendor-id"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      DIRECTION_DOMAIN = [:ltr, :rtl, :ttb_ltr, :ttb_rtl, :weak_ltr, :weak_rtl, :neutral].freeze
      MODIFIER_STATE_DOMAIN = [:no_modifier_mask, :shift_mask, :lock_mask, :control_mask, :alt_mask, :button1_mask, :button2_mask, :button3_mask, :button4_mask, :button5_mask, :super_mask, :hyper_mask, :meta_mask].freeze
      SOURCE_DOMAIN = [:mouse, :pen, :keyboard, :touchscreen, :touchpad, :trackpoint, :tablet_pad].freeze

      attr_reader :active_layout_index, :caps_lock_state, :direction, :display, :has_bidi_layouts, :has_cursor, :layout_names, :modifier_state, :n_axes, :name, :num_lock_state, :num_touches, :product_id, :scroll_lock_state, :seat, :source, :tool, :vendor_id
    end
  end

  module Gdk
    module DevicePad

      TYPE = "Gdk.DevicePad"
      GTYPE = "GdkDevicePad"
      PREREQUISITES = ["Gdk.Device"].freeze
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gdk
    class Surface < GtkAst::GObject::Object

      TYPE = "Gdk.Surface"
      GTYPE = "GdkSurface"
      FIELDS = [:cursor, :display, :frame_clock, :height, :mapped, :scale, :scale_factor, :width].freeze
      PROPERTIES = {cursor: "cursor", display: "display", frame_clock: "frame-clock", height: "height", mapped: "mapped", scale: "scale", scale_factor: "scale-factor", width: "width"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :cursor, :display, :frame_clock, :height, :mapped, :scale, :scale_factor, :width
    end
  end

  module Gdk
    module DragSurface

      TYPE = "Gdk.DragSurface"
      GTYPE = "GdkDragSurface"
      PREREQUISITES = ["Gdk.Surface"].freeze
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gdk
    module Paintable

      TYPE = "Gdk.Paintable"
      GTYPE = "GdkPaintable"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gdk
    module Popup

      TYPE = "Gdk.Popup"
      GTYPE = "GdkPopup"
      PREREQUISITES = ["Gdk.Surface"].freeze
      FIELDS = [:autohide, :parent].freeze
      PROPERTIES = {autohide: "autohide", parent: "parent"}.freeze
      KEYS = FIELDS.dup.freeze

      attr_reader :autohide, :parent
    end
  end

  module Gdk
    module Toplevel

      TYPE = "Gdk.Toplevel"
      GTYPE = "GdkToplevel"
      PREREQUISITES = ["Gdk.Surface"].freeze
      FIELDS = [:capabilities, :decorated, :deletable, :fullscreen_mode, :gravity, :icon_list, :modal, :shortcuts_inhibited, :startup_id, :state, :title, :transient_for].freeze
      PROPERTIES = {capabilities: "capabilities", decorated: "decorated", deletable: "deletable", fullscreen_mode: "fullscreen-mode", gravity: "gravity", icon_list: "icon-list", modal: "modal", shortcuts_inhibited: "shortcuts-inhibited", startup_id: "startup-id", state: "state", title: "title", transient_for: "transient-for"}.freeze
      KEYS = FIELDS.dup.freeze
      CAPABILITIES_DOMAIN = [:edge_constraints, :inhibit_shortcuts, :titlebar_gestures, :window_menu, :maximize, :fullscreen, :minimize, :lower].freeze
      FULLSCREEN_MODE_DOMAIN = [:current_monitor, :all_monitors].freeze
      GRAVITY_DOMAIN = [:north_west, :north, :north_east, :west, :center, :east, :south_west, :south, :south_east, :static].freeze
      STATE_DOMAIN = [:minimized, :maximized, :sticky, :fullscreen, :above, :below, :focused, :tiled, :top_tiled, :top_resizable, :right_tiled, :right_resizable, :bottom_tiled, :bottom_resizable, :left_tiled, :left_resizable, :suspended].freeze

      attr_reader :capabilities, :decorated, :deletable, :fullscreen_mode, :gravity, :icon_list, :modal, :shortcuts_inhibited, :startup_id, :state, :title, :transient_for
    end
  end

  module Gio
    module Action

      TYPE = "Gio.Action"
      GTYPE = "GAction"
      FIELDS = [:enabled, :name, :parameter_type, :state, :state_type].freeze
      PROPERTIES = {enabled: "enabled", name: "name", parameter_type: "parameter-type", state: "state", state_type: "state-type"}.freeze
      KEYS = FIELDS.dup.freeze

      attr_reader :enabled, :name, :parameter_type, :state, :state_type
    end
  end

  module Gio
    module ActionGroup

      TYPE = "Gio.ActionGroup"
      GTYPE = "GActionGroup"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module ActionMap

      TYPE = "Gio.ActionMap"
      GTYPE = "GActionMap"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module AppInfo

      TYPE = "Gio.AppInfo"
      GTYPE = "GAppInfo"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module AsyncInitable

      TYPE = "Gio.AsyncInitable"
      GTYPE = "GAsyncInitable"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module AsyncResult

      TYPE = "Gio.AsyncResult"
      GTYPE = "GAsyncResult"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module Converter

      TYPE = "Gio.Converter"
      GTYPE = "GConverter"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module DBusInterface

      TYPE = "Gio.DBusInterface"
      GTYPE = "GDBusInterface"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module DBusObject

      TYPE = "Gio.DBusObject"
      GTYPE = "GDBusObject"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module DBusObjectManager

      TYPE = "Gio.DBusObjectManager"
      GTYPE = "GDBusObjectManager"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module DatagramBased

      TYPE = "Gio.DatagramBased"
      GTYPE = "GDatagramBased"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module Initable

      TYPE = "Gio.Initable"
      GTYPE = "GInitable"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module DebugController
      include Initable

      TYPE = "Gio.DebugController"
      GTYPE = "GDebugController"
      FIELDS = [:debug_enabled].freeze
      PROPERTIES = {debug_enabled: "debug-enabled"}.freeze
      KEYS = (Initable::FIELDS + FIELDS).uniq.freeze

      attr_reader :debug_enabled
    end
  end

  module Gio
    module Drive

      TYPE = "Gio.Drive"
      GTYPE = "GDrive"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module DtlsConnection
      include DatagramBased

      TYPE = "Gio.DtlsConnection"
      GTYPE = "GDtlsConnection"
      FIELDS = [:advertised_protocols, :base_socket, :certificate, :ciphersuite_name, :database, :interaction, :negotiated_protocol, :peer_certificate, :peer_certificate_errors, :protocol_version, :rehandshake_mode, :require_close_notify].freeze
      PROPERTIES = {advertised_protocols: "advertised-protocols", base_socket: "base-socket", certificate: "certificate", ciphersuite_name: "ciphersuite-name", database: "database", interaction: "interaction", negotiated_protocol: "negotiated-protocol", peer_certificate: "peer-certificate", peer_certificate_errors: "peer-certificate-errors", protocol_version: "protocol-version", rehandshake_mode: "rehandshake-mode", require_close_notify: "require-close-notify"}.freeze
      KEYS = (DatagramBased::FIELDS + FIELDS).uniq.freeze
      PEER_CERTIFICATE_ERRORS_DOMAIN = [:no_flags, :unknown_ca, :bad_identity, :not_activated, :expired, :revoked, :insecure, :generic_error, :validate_all].freeze
      PROTOCOL_VERSION_DOMAIN = [:unknown, :ssl_3_0, :tls_1_0, :tls_1_1, :tls_1_2, :tls_1_3, :dtls_1_0, :dtls_1_2].freeze
      REHANDSHAKE_MODE_DOMAIN = [:never, :safely, :unsafely].freeze

      attr_reader :advertised_protocols, :base_socket, :certificate, :ciphersuite_name, :database, :interaction, :negotiated_protocol, :peer_certificate, :peer_certificate_errors, :protocol_version, :rehandshake_mode, :require_close_notify
    end
  end

  module Gio
    module DtlsClientConnection
      include DatagramBased
      include DtlsConnection

      TYPE = "Gio.DtlsClientConnection"
      GTYPE = "GDtlsClientConnection"
      FIELDS = [:accepted_cas, :server_identity, :validation_flags].freeze
      PROPERTIES = {accepted_cas: "accepted-cas", server_identity: "server-identity", validation_flags: "validation-flags"}.freeze
      KEYS = (DatagramBased::FIELDS + DtlsConnection::FIELDS + FIELDS).uniq.freeze
      VALIDATION_FLAGS_DOMAIN = [:no_flags, :unknown_ca, :bad_identity, :not_activated, :expired, :revoked, :insecure, :generic_error, :validate_all].freeze

      attr_reader :accepted_cas, :server_identity, :validation_flags
    end
  end

  module Gio
    module DtlsServerConnection
      include DatagramBased
      include DtlsConnection

      TYPE = "Gio.DtlsServerConnection"
      GTYPE = "GDtlsServerConnection"
      FIELDS = [:authentication_mode].freeze
      PROPERTIES = {authentication_mode: "authentication-mode"}.freeze
      KEYS = (DatagramBased::FIELDS + DtlsConnection::FIELDS + FIELDS).uniq.freeze
      AUTHENTICATION_MODE_DOMAIN = [:none, :requested, :required].freeze

      attr_reader :authentication_mode
    end
  end

  module Gio
    module File

      TYPE = "Gio.File"
      GTYPE = "GFile"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module Icon

      TYPE = "Gio.Icon"
      GTYPE = "GIcon"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module ListModel

      TYPE = "Gio.ListModel"
      GTYPE = "GListModel"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module LoadableIcon
      include Icon

      TYPE = "Gio.LoadableIcon"
      GTYPE = "GLoadableIcon"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (Icon::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gio
    module MemoryMonitor
      include Initable

      TYPE = "Gio.MemoryMonitor"
      GTYPE = "GMemoryMonitor"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (Initable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gio
    module Mount

      TYPE = "Gio.Mount"
      GTYPE = "GMount"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module NetworkMonitor
      include Initable

      TYPE = "Gio.NetworkMonitor"
      GTYPE = "GNetworkMonitor"
      FIELDS = [:connectivity, :network_available, :network_metered].freeze
      PROPERTIES = {connectivity: "connectivity", network_available: "network-available", network_metered: "network-metered"}.freeze
      KEYS = (Initable::FIELDS + FIELDS).uniq.freeze
      CONNECTIVITY_DOMAIN = [:local, :limited, :portal, :full].freeze

      attr_reader :connectivity, :network_available, :network_metered
    end
  end

  module Gio
    class InputStream < GtkAst::GObject::Object

      TYPE = "Gio.InputStream"
      GTYPE = "GInputStream"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    module PollableInputStream

      TYPE = "Gio.PollableInputStream"
      GTYPE = "GPollableInputStream"
      PREREQUISITES = ["Gio.InputStream"].freeze
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    class OutputStream < GtkAst::GObject::Object

      TYPE = "Gio.OutputStream"
      GTYPE = "GOutputStream"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    module PollableOutputStream

      TYPE = "Gio.PollableOutputStream"
      GTYPE = "GPollableOutputStream"
      PREREQUISITES = ["Gio.OutputStream"].freeze
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module PowerProfileMonitor
      include Initable

      TYPE = "Gio.PowerProfileMonitor"
      GTYPE = "GPowerProfileMonitor"
      FIELDS = [:power_saver_enabled].freeze
      PROPERTIES = {power_saver_enabled: "power-saver-enabled"}.freeze
      KEYS = (Initable::FIELDS + FIELDS).uniq.freeze

      attr_reader :power_saver_enabled
    end
  end

  module Gio
    module Proxy

      TYPE = "Gio.Proxy"
      GTYPE = "GProxy"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module ProxyResolver

      TYPE = "Gio.ProxyResolver"
      GTYPE = "GProxyResolver"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module RemoteActionGroup
      include ActionGroup

      TYPE = "Gio.RemoteActionGroup"
      GTYPE = "GRemoteActionGroup"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (ActionGroup::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gio
    module Seekable

      TYPE = "Gio.Seekable"
      GTYPE = "GSeekable"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module SocketConnectable

      TYPE = "Gio.SocketConnectable"
      GTYPE = "GSocketConnectable"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    module TlsBackend

      TYPE = "Gio.TlsBackend"
      GTYPE = "GTlsBackend"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gio
    class IOStream < GtkAst::GObject::Object

      TYPE = "Gio.IOStream"
      GTYPE = "GIOStream"
      FIELDS = [:closed, :input_stream, :output_stream].freeze
      PROPERTIES = {closed: "closed", input_stream: "input-stream", output_stream: "output-stream"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :closed, :input_stream, :output_stream
    end
  end

  module Gio
    class TlsConnection < IOStream

      TYPE = "Gio.TlsConnection"
      GTYPE = "GTlsConnection"
      FIELDS = [:advertised_protocols, :base_io_stream, :certificate, :ciphersuite_name, :database, :interaction, :negotiated_protocol, :peer_certificate, :peer_certificate_errors, :protocol_version, :rehandshake_mode, :require_close_notify, :use_system_certdb].freeze
      PROPERTIES = {advertised_protocols: "advertised-protocols", base_io_stream: "base-io-stream", certificate: "certificate", ciphersuite_name: "ciphersuite-name", database: "database", interaction: "interaction", negotiated_protocol: "negotiated-protocol", peer_certificate: "peer-certificate", peer_certificate_errors: "peer-certificate-errors", protocol_version: "protocol-version", rehandshake_mode: "rehandshake-mode", require_close_notify: "require-close-notify", use_system_certdb: "use-system-certdb"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      PEER_CERTIFICATE_ERRORS_DOMAIN = [:no_flags, :unknown_ca, :bad_identity, :not_activated, :expired, :revoked, :insecure, :generic_error, :validate_all].freeze
      PROTOCOL_VERSION_DOMAIN = [:unknown, :ssl_3_0, :tls_1_0, :tls_1_1, :tls_1_2, :tls_1_3, :dtls_1_0, :dtls_1_2].freeze
      REHANDSHAKE_MODE_DOMAIN = [:never, :safely, :unsafely].freeze

      attr_reader :advertised_protocols, :base_io_stream, :certificate, :ciphersuite_name, :database, :interaction, :negotiated_protocol, :peer_certificate, :peer_certificate_errors, :protocol_version, :rehandshake_mode, :require_close_notify, :use_system_certdb
    end
  end

  module Gio
    module TlsClientConnection

      TYPE = "Gio.TlsClientConnection"
      GTYPE = "GTlsClientConnection"
      PREREQUISITES = ["Gio.TlsConnection"].freeze
      FIELDS = [:accepted_cas, :server_identity, :use_ssl3, :validation_flags].freeze
      PROPERTIES = {accepted_cas: "accepted-cas", server_identity: "server-identity", use_ssl3: "use-ssl3", validation_flags: "validation-flags"}.freeze
      KEYS = FIELDS.dup.freeze
      VALIDATION_FLAGS_DOMAIN = [:no_flags, :unknown_ca, :bad_identity, :not_activated, :expired, :revoked, :insecure, :generic_error, :validate_all].freeze

      attr_reader :accepted_cas, :server_identity, :use_ssl3, :validation_flags
    end
  end

  module Gio
    class TlsDatabase < GtkAst::GObject::Object

      TYPE = "Gio.TlsDatabase"
      GTYPE = "GTlsDatabase"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    module TlsFileDatabase

      TYPE = "Gio.TlsFileDatabase"
      GTYPE = "GTlsFileDatabase"
      PREREQUISITES = ["Gio.TlsDatabase"].freeze
      FIELDS = [:anchors].freeze
      PROPERTIES = {anchors: "anchors"}.freeze
      KEYS = FIELDS.dup.freeze

      attr_reader :anchors
    end
  end

  module Gio
    module TlsServerConnection

      TYPE = "Gio.TlsServerConnection"
      GTYPE = "GTlsServerConnection"
      PREREQUISITES = ["Gio.TlsConnection"].freeze
      FIELDS = [:authentication_mode].freeze
      PROPERTIES = {authentication_mode: "authentication-mode"}.freeze
      KEYS = FIELDS.dup.freeze
      AUTHENTICATION_MODE_DOMAIN = [:none, :requested, :required].freeze

      attr_reader :authentication_mode
    end
  end

  module Gio
    module Volume

      TYPE = "Gio.Volume"
      GTYPE = "GVolume"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gtk
    module AccessibleHypertext
      include Accessible

      TYPE = "Gtk.AccessibleHypertext"
      GTYPE = "GtkAccessibleHypertext"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (Accessible::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    module AccessibleRange
      include Accessible

      TYPE = "Gtk.AccessibleRange"
      GTYPE = "GtkAccessibleRange"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (Accessible::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    module AccessibleText
      include Accessible

      TYPE = "Gtk.AccessibleText"
      GTYPE = "GtkAccessibleText"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (Accessible::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    module Actionable

      TYPE = "Gtk.Actionable"
      GTYPE = "GtkActionable"
      PREREQUISITES = ["Gtk.Widget"].freeze
      FIELDS = [:action_name, :action_target].freeze
      PROPERTIES = {action_name: "action-name", action_target: "action-target"}.freeze
      KEYS = FIELDS.dup.freeze

      attr_reader :action_name, :action_target
    end
  end

  module Gtk
    module AppChooser

      TYPE = "Gtk.AppChooser"
      GTYPE = "GtkAppChooser"
      PREREQUISITES = ["Gtk.Widget"].freeze
      FIELDS = [:content_type].freeze
      PROPERTIES = {content_type: "content-type"}.freeze
      KEYS = FIELDS.dup.freeze

      attr_reader :content_type
    end
  end

  module Gtk
    module BuilderScope

      TYPE = "Gtk.BuilderScope"
      GTYPE = "GtkBuilderScope"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gtk
    module CellEditable

      TYPE = "Gtk.CellEditable"
      GTYPE = "GtkCellEditable"
      PREREQUISITES = ["Gtk.Widget"].freeze
      FIELDS = [:editing_canceled].freeze
      PROPERTIES = {editing_canceled: "editing-canceled"}.freeze
      KEYS = FIELDS.dup.freeze

      attr_reader :editing_canceled
    end
  end

  module Gtk
    module CellLayout

      TYPE = "Gtk.CellLayout"
      GTYPE = "GtkCellLayout"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gtk
    module ColorChooser

      TYPE = "Gtk.ColorChooser"
      GTYPE = "GtkColorChooser"
      FIELDS = [:rgba, :use_alpha].freeze
      PROPERTIES = {rgba: "rgba", use_alpha: "use-alpha"}.freeze
      KEYS = FIELDS.dup.freeze

      attr_reader :rgba, :use_alpha
    end
  end

  module Gtk
    module Editable

      TYPE = "Gtk.Editable"
      GTYPE = "GtkEditable"
      PREREQUISITES = ["Gtk.Widget"].freeze
      FIELDS = [:cursor_position, :editable, :enable_undo, :max_width_chars, :selection_bound, :text, :width_chars, :xalign].freeze
      PROPERTIES = {cursor_position: "cursor-position", editable: "editable", enable_undo: "enable-undo", max_width_chars: "max-width-chars", selection_bound: "selection-bound", text: "text", width_chars: "width-chars", xalign: "xalign"}.freeze
      KEYS = FIELDS.dup.freeze

      attr_reader :cursor_position, :editable, :enable_undo, :max_width_chars, :selection_bound, :text, :width_chars, :xalign
    end
  end

  module Gtk
    module FileChooser

      TYPE = "Gtk.FileChooser"
      GTYPE = "GtkFileChooser"
      FIELDS = [:action, :create_folders, :filter, :filters, :select_multiple, :shortcut_folders].freeze
      PROPERTIES = {action: "action", create_folders: "create-folders", filter: "filter", filters: "filters", select_multiple: "select-multiple", shortcut_folders: "shortcut-folders"}.freeze
      KEYS = FIELDS.dup.freeze
      ACTION_DOMAIN = [:open, :save, :select_folder].freeze

      attr_reader :action, :create_folders, :filter, :filters, :select_multiple, :shortcut_folders
    end
  end

  module Gtk
    module FontChooser

      TYPE = "Gtk.FontChooser"
      GTYPE = "GtkFontChooser"
      FIELDS = [:font, :font_desc, :font_features, :language, :level, :preview_text, :show_preview_entry].freeze
      PROPERTIES = {font: "font", font_desc: "font-desc", font_features: "font-features", language: "language", level: "level", preview_text: "preview-text", show_preview_entry: "show-preview-entry"}.freeze
      KEYS = FIELDS.dup.freeze
      LEVEL_DOMAIN = [:family, :style, :size, :variations, :features].freeze

      attr_reader :font, :font_desc, :font_features, :language, :level, :preview_text, :show_preview_entry
    end
  end

  module Gtk
    module Native

      TYPE = "Gtk.Native"
      GTYPE = "GtkNative"
      PREREQUISITES = ["Gtk.Widget"].freeze
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gtk
    module Orientable

      TYPE = "Gtk.Orientable"
      GTYPE = "GtkOrientable"
      FIELDS = [:orientation].freeze
      PROPERTIES = {orientation: "orientation"}.freeze
      KEYS = FIELDS.dup.freeze
      ORIENTATION_DOMAIN = [:horizontal, :vertical].freeze

      attr_reader :orientation
    end
  end

  module Gtk
    module PrintOperationPreview

      TYPE = "Gtk.PrintOperationPreview"
      GTYPE = "GtkPrintOperationPreview"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gtk
    module Root
      include Native

      TYPE = "Gtk.Root"
      GTYPE = "GtkRoot"
      PREREQUISITES = ["Gtk.Widget"].freeze
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (Native::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    module Scrollable

      TYPE = "Gtk.Scrollable"
      GTYPE = "GtkScrollable"
      FIELDS = [:hadjustment, :hscroll_policy, :vadjustment, :vscroll_policy].freeze
      PROPERTIES = {hadjustment: "hadjustment", hscroll_policy: "hscroll-policy", vadjustment: "vadjustment", vscroll_policy: "vscroll-policy"}.freeze
      KEYS = FIELDS.dup.freeze
      HSCROLL_POLICY_DOMAIN = [:minimum, :natural].freeze
      VSCROLL_POLICY_DOMAIN = [:minimum, :natural].freeze

      attr_reader :hadjustment, :hscroll_policy, :vadjustment, :vscroll_policy
    end
  end

  module Gtk
    module SectionModel
      include GtkAst::Gio::ListModel

      TYPE = "Gtk.SectionModel"
      GTYPE = "GtkSectionModel"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (GtkAst::Gio::ListModel::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    module SelectionModel
      include GtkAst::Gio::ListModel

      TYPE = "Gtk.SelectionModel"
      GTYPE = "GtkSelectionModel"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (GtkAst::Gio::ListModel::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    module ShortcutManager

      TYPE = "Gtk.ShortcutManager"
      GTYPE = "GtkShortcutManager"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gtk
    module StyleProvider

      TYPE = "Gtk.StyleProvider"
      GTYPE = "GtkStyleProvider"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gtk
    module SymbolicPaintable
      include GtkAst::Gdk::Paintable

      TYPE = "Gtk.SymbolicPaintable"
      GTYPE = "GtkSymbolicPaintable"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (GtkAst::Gdk::Paintable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    module TreeDragDest

      TYPE = "Gtk.TreeDragDest"
      GTYPE = "GtkTreeDragDest"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gtk
    module TreeDragSource

      TYPE = "Gtk.TreeDragSource"
      GTYPE = "GtkTreeDragSource"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gtk
    module TreeModel

      TYPE = "Gtk.TreeModel"
      GTYPE = "GtkTreeModel"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Gtk
    module TreeSortable
      include TreeModel

      TYPE = "Gtk.TreeSortable"
      GTYPE = "GtkTreeSortable"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (TreeModel::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Pango
    class Font < GtkAst::GObject::Object

      TYPE = "Pango.Font"
      GTYPE = "PangoFont"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module PangoCairo
    module Font

      TYPE = "PangoCairo.Font"
      GTYPE = "PangoCairoFont"
      PREREQUISITES = ["Pango.Font"].freeze
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Pango
    class FontMap < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel

      TYPE = "Pango.FontMap"
      GTYPE = "PangoFontMap"
      FIELDS = [:item_type, :n_items].freeze
      PROPERTIES = {item_type: "item-type", n_items: "n-items"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :item_type, :n_items
    end
  end

  module PangoCairo
    module FontMap

      TYPE = "PangoCairo.FontMap"
      GTYPE = "PangoCairoFontMap"
      PREREQUISITES = ["Pango.FontMap"].freeze
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = FIELDS.dup.freeze
    end
  end

  module Adw
    class Dialog < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::ShortcutManager

      TYPE = "Adw.Dialog"
      GTYPE = "AdwDialog"
      FIELDS = [:can_close, :child, :content_height, :content_width, :current_breakpoint, :default_widget, :focus_widget, :follows_content_size, :presentation_mode, :title].freeze
      PROPERTIES = {can_close: "can-close", child: "child", content_height: "content-height", content_width: "content-width", current_breakpoint: "current-breakpoint", default_widget: "default-widget", focus_widget: "focus-widget", follows_content_size: "follows-content-size", presentation_mode: "presentation-mode", title: "title"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::ShortcutManager::FIELDS + FIELDS).uniq.freeze
      PRESENTATION_MODE_DOMAIN = [:auto, :floating, :bottom_sheet].freeze

      attr_reader :can_close, :child, :content_height, :content_width, :current_breakpoint, :default_widget, :focus_widget, :follows_content_size, :presentation_mode, :title
    end
  end

  module Adw
    class AboutDialog < Dialog
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::ShortcutManager

      TYPE = "Adw.AboutDialog"
      GTYPE = "AdwAboutDialog"
      FIELDS = [:appdata_resource_path, :application_icon, :application_name, :artists, :comments, :copyright, :debug_info, :debug_info_filename, :designers, :developer_name, :developers, :documenters, :issue_url, :license, :license_type, :release_notes, :release_notes_version, :support_url, :translator_credits, :version, :website].freeze
      PROPERTIES = {appdata_resource_path: "appdata-resource-path", application_icon: "application-icon", application_name: "application-name", artists: "artists", comments: "comments", copyright: "copyright", debug_info: "debug-info", debug_info_filename: "debug-info-filename", designers: "designers", developer_name: "developer-name", developers: "developers", documenters: "documenters", issue_url: "issue-url", license: "license", license_type: "license-type", release_notes: "release-notes", release_notes_version: "release-notes-version", support_url: "support-url", translator_credits: "translator-credits", version: "version", website: "website"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::ShortcutManager::FIELDS + FIELDS).uniq.freeze
      LICENSE_TYPE_DOMAIN = [:unknown, :custom, :gpl_2_0, :gpl_3_0, :lgpl_2_1, :lgpl_3_0, :bsd, :mit_x11, :artistic, :gpl_2_0_only, :gpl_3_0_only, :lgpl_2_1_only, :lgpl_3_0_only, :agpl_3_0, :agpl_3_0_only, :bsd_3, :apache_2_0, :mpl_2_0, :"0bsd"].freeze

      attr_reader :appdata_resource_path, :application_icon, :application_name, :artists, :comments, :copyright, :debug_info, :debug_info_filename, :designers, :developer_name, :developers, :documenters, :issue_url, :license, :license_type, :release_notes, :release_notes_version, :support_url, :translator_credits, :version, :website
    end
  end

  module Gtk
    class Window < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Native
      include Root
      include ShortcutManager

      TYPE = "Gtk.Window"
      GTYPE = "GtkWindow"
      FIELDS = [:application, :child, :decorated, :default_height, :default_widget, :default_width, :deletable, :destroy_with_parent, :display, :focus_visible, :focus_widget, :fullscreened, :gravity, :handle_menubar_accel, :hide_on_close, :icon_name, :is_active, :maximized, :mnemonics_visible, :modal, :resizable, :startup_id, :suspended, :title, :titlebar, :transient_for].freeze
      PROPERTIES = {application: "application", child: "child", decorated: "decorated", default_height: "default-height", default_widget: "default-widget", default_width: "default-width", deletable: "deletable", destroy_with_parent: "destroy-with-parent", display: "display", focus_visible: "focus-visible", focus_widget: "focus-widget", fullscreened: "fullscreened", gravity: "gravity", handle_menubar_accel: "handle-menubar-accel", hide_on_close: "hide-on-close", icon_name: "icon-name", is_active: "is-active", maximized: "maximized", mnemonics_visible: "mnemonics-visible", modal: "modal", resizable: "resizable", startup_id: "startup-id", suspended: "suspended", title: "title", titlebar: "titlebar", transient_for: "transient-for"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + Root::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze
      GRAVITY_DOMAIN = [:top_left, :top, :top_right, :left, :center, :right, :bottom_left, :bottom, :bottom_right, :top_start, :top_end, :start, :end, :bottom_start, :bottom_end].freeze

      attr_reader :application, :child, :decorated, :default_height, :default_widget, :default_width, :deletable, :destroy_with_parent, :display, :focus_visible, :focus_widget, :fullscreened, :gravity, :handle_menubar_accel, :hide_on_close, :icon_name, :is_active, :maximized, :mnemonics_visible, :modal, :resizable, :startup_id, :suspended, :title, :titlebar, :transient_for
    end
  end

  module Adw
    class Window < GtkAst::Gtk::Window
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Native
      include GtkAst::Gtk::Root
      include GtkAst::Gtk::ShortcutManager

      TYPE = "Adw.Window"
      GTYPE = "AdwWindow"
      FIELDS = [:adaptive_preview, :content, :current_breakpoint, :dialogs, :visible_dialog].freeze
      PROPERTIES = {adaptive_preview: "adaptive-preview", content: "content", current_breakpoint: "current-breakpoint", dialogs: "dialogs", visible_dialog: "visible-dialog"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Native::FIELDS + GtkAst::Gtk::Root::FIELDS + GtkAst::Gtk::ShortcutManager::FIELDS + FIELDS).uniq.freeze

      attr_reader :adaptive_preview, :content, :current_breakpoint, :dialogs, :visible_dialog
    end
  end

  module Adw
    class AboutWindow < Window
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Native
      include GtkAst::Gtk::Root
      include GtkAst::Gtk::ShortcutManager

      TYPE = "Adw.AboutWindow"
      GTYPE = "AdwAboutWindow"
      FIELDS = [:application_icon, :application_name, :artists, :comments, :copyright, :debug_info, :debug_info_filename, :designers, :developer_name, :developers, :documenters, :issue_url, :license, :license_type, :release_notes, :release_notes_version, :support_url, :translator_credits, :version, :website].freeze
      PROPERTIES = {application_icon: "application-icon", application_name: "application-name", artists: "artists", comments: "comments", copyright: "copyright", debug_info: "debug-info", debug_info_filename: "debug-info-filename", designers: "designers", developer_name: "developer-name", developers: "developers", documenters: "documenters", issue_url: "issue-url", license: "license", license_type: "license-type", release_notes: "release-notes", release_notes_version: "release-notes-version", support_url: "support-url", translator_credits: "translator-credits", version: "version", website: "website"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Native::FIELDS + GtkAst::Gtk::Root::FIELDS + GtkAst::Gtk::ShortcutManager::FIELDS + FIELDS).uniq.freeze
      LICENSE_TYPE_DOMAIN = [:unknown, :custom, :gpl_2_0, :gpl_3_0, :lgpl_2_1, :lgpl_3_0, :bsd, :mit_x11, :artistic, :gpl_2_0_only, :gpl_3_0_only, :lgpl_2_1_only, :lgpl_3_0_only, :agpl_3_0, :agpl_3_0_only, :bsd_3, :apache_2_0, :mpl_2_0, :"0bsd"].freeze

      attr_reader :application_icon, :application_name, :artists, :comments, :copyright, :debug_info, :debug_info_filename, :designers, :developer_name, :developers, :documenters, :issue_url, :license, :license_type, :release_notes, :release_notes_version, :support_url, :translator_credits, :version, :website
    end
  end

  module Gtk
    class ListBoxRow < Widget
      include Accessible
      include Actionable
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.ListBoxRow"
      GTYPE = "GtkListBoxRow"
      FIELDS = [:activatable, :child, :selectable].freeze
      PROPERTIES = {activatable: "activatable", child: "child", selectable: "selectable"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Actionable::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :activatable, :child, :selectable
    end
  end

  module Adw
    class PreferencesRow < GtkAst::Gtk::ListBoxRow
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Actionable
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.PreferencesRow"
      GTYPE = "AdwPreferencesRow"
      FIELDS = [:title, :title_selectable, :use_markup, :use_underline].freeze
      PROPERTIES = {title: "title", title_selectable: "title-selectable", use_markup: "use-markup", use_underline: "use-underline"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Actionable::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :title, :title_selectable, :use_markup, :use_underline
    end
  end

  module Adw
    class ActionRow < PreferencesRow
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Actionable
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.ActionRow"
      GTYPE = "AdwActionRow"
      FIELDS = [:activatable_widget, :icon_name, :subtitle, :subtitle_lines, :subtitle_selectable, :title_lines].freeze
      PROPERTIES = {activatable_widget: "activatable-widget", icon_name: "icon-name", subtitle: "subtitle", subtitle_lines: "subtitle-lines", subtitle_selectable: "subtitle-selectable", title_lines: "title-lines"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Actionable::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :activatable_widget, :icon_name, :subtitle, :subtitle_lines, :subtitle_selectable, :title_lines
    end
  end

  module Adw
    class AlertDialog < Dialog
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::ShortcutManager

      TYPE = "Adw.AlertDialog"
      GTYPE = "AdwAlertDialog"
      FIELDS = [:body, :body_use_markup, :close_response, :default_response, :extra_child, :heading, :heading_use_markup, :prefer_wide_layout].freeze
      PROPERTIES = {body: "body", body_use_markup: "body-use-markup", close_response: "close-response", default_response: "default-response", extra_child: "extra-child", heading: "heading", heading_use_markup: "heading-use-markup", prefer_wide_layout: "prefer-wide-layout"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::ShortcutManager::FIELDS + FIELDS).uniq.freeze

      attr_reader :body, :body_use_markup, :close_response, :default_response, :extra_child, :heading, :heading_use_markup, :prefer_wide_layout
    end
  end

  module Adw
    class Animation < GtkAst::GObject::Object

      TYPE = "Adw.Animation"
      GTYPE = "AdwAnimation"
      FIELDS = [:follow_enable_animations_setting, :state, :target, :value, :widget].freeze
      PROPERTIES = {follow_enable_animations_setting: "follow-enable-animations-setting", state: "state", target: "target", value: "value", widget: "widget"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      STATE_DOMAIN = [:idle, :paused, :playing, :finished].freeze

      attr_reader :follow_enable_animations_setting, :state, :target, :value, :widget
    end
  end

  module Adw
    class AnimationTarget < GtkAst::GObject::Object

      TYPE = "Adw.AnimationTarget"
      GTYPE = "AdwAnimationTarget"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class Application < GtkAst::GObject::Object
      include ActionGroup
      include ActionMap

      TYPE = "Gio.Application"
      GTYPE = "GApplication"
      FIELDS = [:action_group, :application_id, :flags, :inactivity_timeout, :is_busy, :is_registered, :is_remote, :resource_base_path, :version].freeze
      PROPERTIES = {action_group: "action-group", application_id: "application-id", flags: "flags", inactivity_timeout: "inactivity-timeout", is_busy: "is-busy", is_registered: "is-registered", is_remote: "is-remote", resource_base_path: "resource-base-path", version: "version"}.freeze
      KEYS = (superclass::KEYS + ActionGroup::FIELDS + ActionMap::FIELDS + FIELDS).uniq.freeze
      FLAGS_DOMAIN = [:flags_none, :default_flags, :is_service, :is_launcher, :handles_open, :handles_command_line, :send_environment, :non_unique, :can_override_app_id, :allow_replacement, :replace].freeze

      attr_reader :action_group, :application_id, :flags, :inactivity_timeout, :is_busy, :is_registered, :is_remote, :resource_base_path, :version
    end
  end

  module Gtk
    class Application < GtkAst::Gio::Application
      include GtkAst::Gio::ActionGroup
      include GtkAst::Gio::ActionMap

      TYPE = "Gtk.Application"
      GTYPE = "GtkApplication"
      FIELDS = [:active_window, :menubar, :register_session, :screensaver_active].freeze
      PROPERTIES = {active_window: "active-window", menubar: "menubar", register_session: "register-session", screensaver_active: "screensaver-active"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ActionGroup::FIELDS + GtkAst::Gio::ActionMap::FIELDS + FIELDS).uniq.freeze

      attr_reader :active_window, :menubar, :register_session, :screensaver_active
    end
  end

  module Adw
    class Application < GtkAst::Gtk::Application
      include GtkAst::Gio::ActionGroup
      include GtkAst::Gio::ActionMap

      TYPE = "Adw.Application"
      GTYPE = "AdwApplication"
      FIELDS = [:style_manager].freeze
      PROPERTIES = {style_manager: "style-manager"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ActionGroup::FIELDS + GtkAst::Gio::ActionMap::FIELDS + FIELDS).uniq.freeze

      attr_reader :style_manager
    end
  end

  module Gtk
    class ApplicationWindow < Window
      include GtkAst::Gio::ActionGroup
      include GtkAst::Gio::ActionMap
      include Accessible
      include Buildable
      include ConstraintTarget
      include Native
      include Root
      include ShortcutManager

      TYPE = "Gtk.ApplicationWindow"
      GTYPE = "GtkApplicationWindow"
      FIELDS = [:show_menubar].freeze
      PROPERTIES = {show_menubar: "show-menubar"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ActionGroup::FIELDS + GtkAst::Gio::ActionMap::FIELDS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + Root::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze

      attr_reader :show_menubar
    end
  end

  module Adw
    class ApplicationWindow < GtkAst::Gtk::ApplicationWindow
      include GtkAst::Gio::ActionGroup
      include GtkAst::Gio::ActionMap
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Native
      include GtkAst::Gtk::Root
      include GtkAst::Gtk::ShortcutManager

      TYPE = "Adw.ApplicationWindow"
      GTYPE = "AdwApplicationWindow"
      FIELDS = [:adaptive_preview, :content, :current_breakpoint, :dialogs, :visible_dialog].freeze
      PROPERTIES = {adaptive_preview: "adaptive-preview", content: "content", current_breakpoint: "current-breakpoint", dialogs: "dialogs", visible_dialog: "visible-dialog"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ActionGroup::FIELDS + GtkAst::Gio::ActionMap::FIELDS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Native::FIELDS + GtkAst::Gtk::Root::FIELDS + GtkAst::Gtk::ShortcutManager::FIELDS + FIELDS).uniq.freeze

      attr_reader :adaptive_preview, :content, :current_breakpoint, :dialogs, :visible_dialog
    end
  end

  module Adw
    class Avatar < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.Avatar"
      GTYPE = "AdwAvatar"
      FIELDS = [:custom_image, :icon_name, :show_initials, :size, :text].freeze
      PROPERTIES = {custom_image: "custom-image", icon_name: "icon-name", show_initials: "show-initials", size: "size", text: "text"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :custom_image, :icon_name, :show_initials, :size, :text
    end
  end

  module Adw
    class Banner < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Actionable
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.Banner"
      GTYPE = "AdwBanner"
      FIELDS = [:button_label, :button_style, :revealed, :title, :use_markup].freeze
      PROPERTIES = {button_label: "button-label", button_style: "button-style", revealed: "revealed", title: "title", use_markup: "use-markup"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Actionable::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      BUTTON_STYLE_DOMAIN = [:default, :suggested].freeze

      attr_reader :button_label, :button_style, :revealed, :title, :use_markup
    end
  end

  module Adw
    class Bin < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.Bin"
      GTYPE = "AdwBin"
      FIELDS = [:child].freeze
      PROPERTIES = {child: "child"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :child
    end
  end

  module Adw
    class BottomSheet < GtkAst::Gtk::Widget
      include Swipeable
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.BottomSheet"
      GTYPE = "AdwBottomSheet"
      FIELDS = [:align, :bottom_bar, :bottom_bar_height, :can_close, :can_open, :content, :full_width, :modal, :open, :reveal_bottom_bar, :sheet, :sheet_height, :show_drag_handle].freeze
      PROPERTIES = {align: "align", bottom_bar: "bottom-bar", bottom_bar_height: "bottom-bar-height", can_close: "can-close", can_open: "can-open", content: "content", full_width: "full-width", modal: "modal", open: "open", reveal_bottom_bar: "reveal-bottom-bar", sheet: "sheet", sheet_height: "sheet-height", show_drag_handle: "show-drag-handle"}.freeze
      KEYS = (superclass::KEYS + Swipeable::FIELDS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :align, :bottom_bar, :bottom_bar_height, :can_close, :can_open, :content, :full_width, :modal, :open, :reveal_bottom_bar, :sheet, :sheet_height, :show_drag_handle
    end
  end

  module Adw
    class Breakpoint < GtkAst::GObject::Object
      include GtkAst::Gtk::Buildable

      TYPE = "Adw.Breakpoint"
      GTYPE = "AdwBreakpoint"
      FIELDS = [:condition].freeze
      PROPERTIES = {condition: "condition"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Buildable::FIELDS + FIELDS).uniq.freeze

      attr_reader :condition
    end
  end

  module Adw
    class BreakpointBin < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.BreakpointBin"
      GTYPE = "AdwBreakpointBin"
      FIELDS = [:child, :current_breakpoint].freeze
      PROPERTIES = {child: "child", current_breakpoint: "current-breakpoint"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :child, :current_breakpoint
    end
  end

  module Adw
    class ButtonContent < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.ButtonContent"
      GTYPE = "AdwButtonContent"
      FIELDS = [:can_shrink, :icon_name, :label, :use_underline].freeze
      PROPERTIES = {can_shrink: "can-shrink", icon_name: "icon-name", label: "label", use_underline: "use-underline"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :can_shrink, :icon_name, :label, :use_underline
    end
  end

  module Adw
    class ButtonRow < PreferencesRow
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Actionable
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.ButtonRow"
      GTYPE = "AdwButtonRow"
      FIELDS = [:end_icon_name, :start_icon_name].freeze
      PROPERTIES = {end_icon_name: "end-icon-name", start_icon_name: "start-icon-name"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Actionable::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :end_icon_name, :start_icon_name
    end
  end

  module Adw
    class CallbackAnimationTarget < AnimationTarget

      TYPE = "Adw.CallbackAnimationTarget"
      GTYPE = "AdwCallbackAnimationTarget"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Adw
    class Carousel < GtkAst::Gtk::Widget
      include Swipeable
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Orientable

      TYPE = "Adw.Carousel"
      GTYPE = "AdwCarousel"
      FIELDS = [:allow_long_swipes, :allow_mouse_drag, :allow_scroll_wheel, :interactive, :n_pages, :position, :reveal_duration, :scroll_params, :spacing].freeze
      PROPERTIES = {allow_long_swipes: "allow-long-swipes", allow_mouse_drag: "allow-mouse-drag", allow_scroll_wheel: "allow-scroll-wheel", interactive: "interactive", n_pages: "n-pages", position: "position", reveal_duration: "reveal-duration", scroll_params: "scroll-params", spacing: "spacing"}.freeze
      KEYS = (superclass::KEYS + Swipeable::FIELDS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :allow_long_swipes, :allow_mouse_drag, :allow_scroll_wheel, :interactive, :n_pages, :position, :reveal_duration, :scroll_params, :spacing
    end
  end

  module Adw
    class CarouselIndicatorDots < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Orientable

      TYPE = "Adw.CarouselIndicatorDots"
      GTYPE = "AdwCarouselIndicatorDots"
      FIELDS = [:carousel].freeze
      PROPERTIES = {carousel: "carousel"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :carousel
    end
  end

  module Adw
    class CarouselIndicatorLines < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Orientable

      TYPE = "Adw.CarouselIndicatorLines"
      GTYPE = "AdwCarouselIndicatorLines"
      FIELDS = [:carousel].freeze
      PROPERTIES = {carousel: "carousel"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :carousel
    end
  end

  module Adw
    class Clamp < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Orientable

      TYPE = "Adw.Clamp"
      GTYPE = "AdwClamp"
      FIELDS = [:child, :maximum_size, :tightening_threshold, :unit].freeze
      PROPERTIES = {child: "child", maximum_size: "maximum-size", tightening_threshold: "tightening-threshold", unit: "unit"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Orientable::FIELDS + FIELDS).uniq.freeze
      UNIT_DOMAIN = [:px, :pt, :sp].freeze

      attr_reader :child, :maximum_size, :tightening_threshold, :unit
    end
  end

  module Gtk
    class LayoutManager < GtkAst::GObject::Object

      TYPE = "Gtk.LayoutManager"
      GTYPE = "GtkLayoutManager"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Adw
    class ClampLayout < GtkAst::Gtk::LayoutManager
      include GtkAst::Gtk::Orientable

      TYPE = "Adw.ClampLayout"
      GTYPE = "AdwClampLayout"
      FIELDS = [:maximum_size, :tightening_threshold, :unit].freeze
      PROPERTIES = {maximum_size: "maximum-size", tightening_threshold: "tightening-threshold", unit: "unit"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Orientable::FIELDS + FIELDS).uniq.freeze
      UNIT_DOMAIN = [:px, :pt, :sp].freeze

      attr_reader :maximum_size, :tightening_threshold, :unit
    end
  end

  module Adw
    class ClampScrollable < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Orientable
      include GtkAst::Gtk::Scrollable

      TYPE = "Adw.ClampScrollable"
      GTYPE = "AdwClampScrollable"
      FIELDS = [:child, :maximum_size, :tightening_threshold, :unit].freeze
      PROPERTIES = {child: "child", maximum_size: "maximum-size", tightening_threshold: "tightening-threshold", unit: "unit"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Orientable::FIELDS + GtkAst::Gtk::Scrollable::FIELDS + FIELDS).uniq.freeze
      UNIT_DOMAIN = [:px, :pt, :sp].freeze

      attr_reader :child, :maximum_size, :tightening_threshold, :unit
    end
  end

  module Adw
    class ComboRow < ActionRow
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Actionable
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.ComboRow"
      GTYPE = "AdwComboRow"
      FIELDS = [:enable_search, :expression, :factory, :header_factory, :list_factory, :model, :search_match_mode, :selected, :selected_item, :use_subtitle].freeze
      PROPERTIES = {enable_search: "enable-search", expression: "expression", factory: "factory", header_factory: "header-factory", list_factory: "list-factory", model: "model", search_match_mode: "search-match-mode", selected: "selected", selected_item: "selected-item", use_subtitle: "use-subtitle"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Actionable::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      SEARCH_MATCH_MODE_DOMAIN = [:exact, :substring, :prefix].freeze

      attr_reader :enable_search, :expression, :factory, :header_factory, :list_factory, :model, :search_match_mode, :selected, :selected_item, :use_subtitle
    end
  end

  module Adw
    class EntryRow < PreferencesRow
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Actionable
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Editable

      TYPE = "Adw.EntryRow"
      GTYPE = "AdwEntryRow"
      FIELDS = [:activates_default, :attributes, :enable_emoji_completion, :input_hints, :input_purpose, :max_length, :show_apply_button, :text_length].freeze
      PROPERTIES = {activates_default: "activates-default", attributes: "attributes", enable_emoji_completion: "enable-emoji-completion", input_hints: "input-hints", input_purpose: "input-purpose", max_length: "max-length", show_apply_button: "show-apply-button", text_length: "text-length"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Actionable::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Editable::FIELDS + FIELDS).uniq.freeze
      INPUT_HINTS_DOMAIN = [:none, :spellcheck, :no_spellcheck, :word_completion, :lowercase, :uppercase_chars, :uppercase_words, :uppercase_sentences, :inhibit_osk, :vertical_writing, :emoji, :no_emoji, :private].freeze
      INPUT_PURPOSE_DOMAIN = [:free_form, :alpha, :digits, :number, :phone, :url, :email, :name, :password, :pin, :terminal].freeze

      attr_reader :activates_default, :attributes, :enable_emoji_completion, :input_hints, :input_purpose, :max_length, :show_apply_button, :text_length
    end
  end

  module Adw
    class EnumListItem < GtkAst::GObject::Object

      TYPE = "Adw.EnumListItem"
      GTYPE = "AdwEnumListItem"
      FIELDS = [:name, :nick, :value].freeze
      PROPERTIES = {name: "name", nick: "nick", value: "value"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :name, :nick, :value
    end
  end

  module Adw
    class EnumListModel < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel

      TYPE = "Adw.EnumListModel"
      GTYPE = "AdwEnumListModel"
      FIELDS = [:enum_type, :item_type, :n_items].freeze
      PROPERTIES = {enum_type: "enum-type", item_type: "item-type", n_items: "n-items"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :enum_type, :item_type, :n_items
    end
  end

  module Adw
    class ExpanderRow < PreferencesRow
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Actionable
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.ExpanderRow"
      GTYPE = "AdwExpanderRow"
      FIELDS = [:enable_expansion, :expanded, :icon_name, :show_enable_switch, :subtitle, :subtitle_lines, :title_lines].freeze
      PROPERTIES = {enable_expansion: "enable-expansion", expanded: "expanded", icon_name: "icon-name", show_enable_switch: "show-enable-switch", subtitle: "subtitle", subtitle_lines: "subtitle-lines", title_lines: "title-lines"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Actionable::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :enable_expansion, :expanded, :icon_name, :show_enable_switch, :subtitle, :subtitle_lines, :title_lines
    end
  end

  module Adw
    class Flap < GtkAst::Gtk::Widget
      include Swipeable
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Orientable

      TYPE = "Adw.Flap"
      GTYPE = "AdwFlap"
      FIELDS = [:content, :flap, :flap_position, :fold_duration, :fold_policy, :fold_threshold_policy, :folded, :locked, :modal, :reveal_flap, :reveal_params, :reveal_progress, :separator, :swipe_to_close, :swipe_to_open, :transition_type].freeze
      PROPERTIES = {content: "content", flap: "flap", flap_position: "flap-position", fold_duration: "fold-duration", fold_policy: "fold-policy", fold_threshold_policy: "fold-threshold-policy", folded: "folded", locked: "locked", modal: "modal", reveal_flap: "reveal-flap", reveal_params: "reveal-params", reveal_progress: "reveal-progress", separator: "separator", swipe_to_close: "swipe-to-close", swipe_to_open: "swipe-to-open", transition_type: "transition-type"}.freeze
      KEYS = (superclass::KEYS + Swipeable::FIELDS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Orientable::FIELDS + FIELDS).uniq.freeze
      FLAP_POSITION_DOMAIN = [:start, :end].freeze
      FOLD_POLICY_DOMAIN = [:never, :always, :auto].freeze
      FOLD_THRESHOLD_POLICY_DOMAIN = [:minimum, :natural].freeze
      TRANSITION_TYPE_DOMAIN = [:over, :under, :slide].freeze

      attr_reader :content, :flap, :flap_position, :fold_duration, :fold_policy, :fold_threshold_policy, :folded, :locked, :modal, :reveal_flap, :reveal_params, :reveal_progress, :separator, :swipe_to_close, :swipe_to_open, :transition_type
    end
  end

  module Adw
    class HeaderBar < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.HeaderBar"
      GTYPE = "AdwHeaderBar"
      FIELDS = [:centering_policy, :decoration_layout, :show_back_button, :show_end_title_buttons, :show_start_title_buttons, :show_title, :title_widget].freeze
      PROPERTIES = {centering_policy: "centering-policy", decoration_layout: "decoration-layout", show_back_button: "show-back-button", show_end_title_buttons: "show-end-title-buttons", show_start_title_buttons: "show-start-title-buttons", show_title: "show-title", title_widget: "title-widget"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      CENTERING_POLICY_DOMAIN = [:loose, :strict].freeze

      attr_reader :centering_policy, :decoration_layout, :show_back_button, :show_end_title_buttons, :show_start_title_buttons, :show_title, :title_widget
    end
  end

  module Adw
    class InlineViewSwitcher < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Orientable

      TYPE = "Adw.InlineViewSwitcher"
      GTYPE = "AdwInlineViewSwitcher"
      FIELDS = [:can_shrink, :display_mode, :homogeneous, :stack].freeze
      PROPERTIES = {can_shrink: "can-shrink", display_mode: "display-mode", homogeneous: "homogeneous", stack: "stack"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Orientable::FIELDS + FIELDS).uniq.freeze
      DISPLAY_MODE_DOMAIN = [:labels, :icons, :both].freeze

      attr_reader :can_shrink, :display_mode, :homogeneous, :stack
    end
  end

  module Adw
    class Layout < GtkAst::GObject::Object
      include GtkAst::Gtk::Buildable

      TYPE = "Adw.Layout"
      GTYPE = "AdwLayout"
      FIELDS = [:content, :name].freeze
      PROPERTIES = {content: "content", name: "name"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Buildable::FIELDS + FIELDS).uniq.freeze

      attr_reader :content, :name
    end
  end

  module Adw
    class LayoutSlot < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.LayoutSlot"
      GTYPE = "AdwLayoutSlot"
      FIELDS = [:id].freeze
      PROPERTIES = {id: "id"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :id
    end
  end

  module Adw
    class Leaflet < GtkAst::Gtk::Widget
      include Swipeable
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Orientable

      TYPE = "Adw.Leaflet"
      GTYPE = "AdwLeaflet"
      FIELDS = [:can_navigate_back, :can_navigate_forward, :can_unfold, :child_transition_params, :child_transition_running, :fold_threshold_policy, :folded, :homogeneous, :mode_transition_duration, :pages, :transition_type, :visible_child, :visible_child_name].freeze
      PROPERTIES = {can_navigate_back: "can-navigate-back", can_navigate_forward: "can-navigate-forward", can_unfold: "can-unfold", child_transition_params: "child-transition-params", child_transition_running: "child-transition-running", fold_threshold_policy: "fold-threshold-policy", folded: "folded", homogeneous: "homogeneous", mode_transition_duration: "mode-transition-duration", pages: "pages", transition_type: "transition-type", visible_child: "visible-child", visible_child_name: "visible-child-name"}.freeze
      KEYS = (superclass::KEYS + Swipeable::FIELDS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Orientable::FIELDS + FIELDS).uniq.freeze
      FOLD_THRESHOLD_POLICY_DOMAIN = [:minimum, :natural].freeze
      TRANSITION_TYPE_DOMAIN = [:over, :under, :slide].freeze

      attr_reader :can_navigate_back, :can_navigate_forward, :can_unfold, :child_transition_params, :child_transition_running, :fold_threshold_policy, :folded, :homogeneous, :mode_transition_duration, :pages, :transition_type, :visible_child, :visible_child_name
    end
  end

  module Adw
    class LeafletPage < GtkAst::GObject::Object

      TYPE = "Adw.LeafletPage"
      GTYPE = "AdwLeafletPage"
      FIELDS = [:child, :name, :navigatable].freeze
      PROPERTIES = {child: "child", name: "name", navigatable: "navigatable"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :child, :name, :navigatable
    end
  end

  module Adw
    class MessageDialog < GtkAst::Gtk::Window
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Native
      include GtkAst::Gtk::Root
      include GtkAst::Gtk::ShortcutManager

      TYPE = "Adw.MessageDialog"
      GTYPE = "AdwMessageDialog"
      FIELDS = [:body, :body_use_markup, :close_response, :default_response, :extra_child, :heading, :heading_use_markup].freeze
      PROPERTIES = {body: "body", body_use_markup: "body-use-markup", close_response: "close-response", default_response: "default-response", extra_child: "extra-child", heading: "heading", heading_use_markup: "heading-use-markup"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Native::FIELDS + GtkAst::Gtk::Root::FIELDS + GtkAst::Gtk::ShortcutManager::FIELDS + FIELDS).uniq.freeze

      attr_reader :body, :body_use_markup, :close_response, :default_response, :extra_child, :heading, :heading_use_markup
    end
  end

  module Adw
    class MultiLayoutView < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.MultiLayoutView"
      GTYPE = "AdwMultiLayoutView"
      FIELDS = [:layout, :layout_name].freeze
      PROPERTIES = {layout: "layout", layout_name: "layout-name"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :layout, :layout_name
    end
  end

  module Adw
    class NavigationPage < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.NavigationPage"
      GTYPE = "AdwNavigationPage"
      FIELDS = [:can_pop, :child, :tag, :title].freeze
      PROPERTIES = {can_pop: "can-pop", child: "child", tag: "tag", title: "title"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :can_pop, :child, :tag, :title
    end
  end

  module Adw
    class NavigationSplitView < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.NavigationSplitView"
      GTYPE = "AdwNavigationSplitView"
      FIELDS = [:collapsed, :content, :max_sidebar_width, :min_sidebar_width, :show_content, :sidebar, :sidebar_position, :sidebar_width_fraction, :sidebar_width_unit].freeze
      PROPERTIES = {collapsed: "collapsed", content: "content", max_sidebar_width: "max-sidebar-width", min_sidebar_width: "min-sidebar-width", show_content: "show-content", sidebar: "sidebar", sidebar_position: "sidebar-position", sidebar_width_fraction: "sidebar-width-fraction", sidebar_width_unit: "sidebar-width-unit"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      SIDEBAR_POSITION_DOMAIN = [:start, :end].freeze
      SIDEBAR_WIDTH_UNIT_DOMAIN = [:px, :pt, :sp].freeze

      attr_reader :collapsed, :content, :max_sidebar_width, :min_sidebar_width, :show_content, :sidebar, :sidebar_position, :sidebar_width_fraction, :sidebar_width_unit
    end
  end

  module Adw
    class NavigationView < GtkAst::Gtk::Widget
      include Swipeable
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.NavigationView"
      GTYPE = "AdwNavigationView"
      FIELDS = [:animate_transitions, :hhomogeneous, :navigation_stack, :pop_on_escape, :vhomogeneous, :visible_page, :visible_page_tag].freeze
      PROPERTIES = {animate_transitions: "animate-transitions", hhomogeneous: "hhomogeneous", navigation_stack: "navigation-stack", pop_on_escape: "pop-on-escape", vhomogeneous: "vhomogeneous", visible_page: "visible-page", visible_page_tag: "visible-page-tag"}.freeze
      KEYS = (superclass::KEYS + Swipeable::FIELDS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :animate_transitions, :hhomogeneous, :navigation_stack, :pop_on_escape, :vhomogeneous, :visible_page, :visible_page_tag
    end
  end

  module Adw
    class NoneAnimationTarget < AnimationTarget

      TYPE = "Adw.NoneAnimationTarget"
      GTYPE = "AdwNoneAnimationTarget"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Adw
    class OverlaySplitView < GtkAst::Gtk::Widget
      include Swipeable
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.OverlaySplitView"
      GTYPE = "AdwOverlaySplitView"
      FIELDS = [:collapsed, :content, :enable_hide_gesture, :enable_show_gesture, :max_sidebar_width, :min_sidebar_width, :pin_sidebar, :show_sidebar, :sidebar, :sidebar_position, :sidebar_width_fraction, :sidebar_width_unit].freeze
      PROPERTIES = {collapsed: "collapsed", content: "content", enable_hide_gesture: "enable-hide-gesture", enable_show_gesture: "enable-show-gesture", max_sidebar_width: "max-sidebar-width", min_sidebar_width: "min-sidebar-width", pin_sidebar: "pin-sidebar", show_sidebar: "show-sidebar", sidebar: "sidebar", sidebar_position: "sidebar-position", sidebar_width_fraction: "sidebar-width-fraction", sidebar_width_unit: "sidebar-width-unit"}.freeze
      KEYS = (superclass::KEYS + Swipeable::FIELDS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      SIDEBAR_POSITION_DOMAIN = [:start, :end].freeze
      SIDEBAR_WIDTH_UNIT_DOMAIN = [:px, :pt, :sp].freeze

      attr_reader :collapsed, :content, :enable_hide_gesture, :enable_show_gesture, :max_sidebar_width, :min_sidebar_width, :pin_sidebar, :show_sidebar, :sidebar, :sidebar_position, :sidebar_width_fraction, :sidebar_width_unit
    end
  end

  module Adw
    class PasswordEntryRow < EntryRow
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Actionable
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Editable

      TYPE = "Adw.PasswordEntryRow"
      GTYPE = "AdwPasswordEntryRow"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Actionable::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Editable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Adw
    class PreferencesDialog < Dialog
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::ShortcutManager

      TYPE = "Adw.PreferencesDialog"
      GTYPE = "AdwPreferencesDialog"
      FIELDS = [:search_enabled, :visible_page, :visible_page_name].freeze
      PROPERTIES = {search_enabled: "search-enabled", visible_page: "visible-page", visible_page_name: "visible-page-name"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::ShortcutManager::FIELDS + FIELDS).uniq.freeze

      attr_reader :search_enabled, :visible_page, :visible_page_name
    end
  end

  module Adw
    class PreferencesGroup < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.PreferencesGroup"
      GTYPE = "AdwPreferencesGroup"
      FIELDS = [:description, :header_suffix, :separate_rows, :title].freeze
      PROPERTIES = {description: "description", header_suffix: "header-suffix", separate_rows: "separate-rows", title: "title"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :description, :header_suffix, :separate_rows, :title
    end
  end

  module Adw
    class PreferencesPage < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.PreferencesPage"
      GTYPE = "AdwPreferencesPage"
      FIELDS = [:banner, :description, :description_centered, :icon_name, :name, :title, :use_underline].freeze
      PROPERTIES = {banner: "banner", description: "description", description_centered: "description-centered", icon_name: "icon-name", name: "name", title: "title", use_underline: "use-underline"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :banner, :description, :description_centered, :icon_name, :name, :title, :use_underline
    end
  end

  module Adw
    class PreferencesWindow < Window
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Native
      include GtkAst::Gtk::Root
      include GtkAst::Gtk::ShortcutManager

      TYPE = "Adw.PreferencesWindow"
      GTYPE = "AdwPreferencesWindow"
      FIELDS = [:can_navigate_back, :search_enabled, :visible_page, :visible_page_name].freeze
      PROPERTIES = {can_navigate_back: "can-navigate-back", search_enabled: "search-enabled", visible_page: "visible-page", visible_page_name: "visible-page-name"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Native::FIELDS + GtkAst::Gtk::Root::FIELDS + GtkAst::Gtk::ShortcutManager::FIELDS + FIELDS).uniq.freeze

      attr_reader :can_navigate_back, :search_enabled, :visible_page, :visible_page_name
    end
  end

  module Adw
    class PropertyAnimationTarget < AnimationTarget

      TYPE = "Adw.PropertyAnimationTarget"
      GTYPE = "AdwPropertyAnimationTarget"
      FIELDS = [:object, :pspec].freeze
      PROPERTIES = {object: "object", pspec: "pspec"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :object, :pspec
    end
  end

  module Adw
    class ShortcutLabel < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.ShortcutLabel"
      GTYPE = "AdwShortcutLabel"
      FIELDS = [:accelerator, :disabled_text].freeze
      PROPERTIES = {accelerator: "accelerator", disabled_text: "disabled-text"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :accelerator, :disabled_text
    end
  end

  module Adw
    class ShortcutsDialog < Dialog
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::ShortcutManager

      TYPE = "Adw.ShortcutsDialog"
      GTYPE = "AdwShortcutsDialog"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::ShortcutManager::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Adw
    class ShortcutsItem < GtkAst::GObject::Object

      TYPE = "Adw.ShortcutsItem"
      GTYPE = "AdwShortcutsItem"
      FIELDS = [:accelerator, :action_name, :direction, :subtitle, :title].freeze
      PROPERTIES = {accelerator: "accelerator", action_name: "action-name", direction: "direction", subtitle: "subtitle", title: "title"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      DIRECTION_DOMAIN = [:none, :ltr, :rtl].freeze

      attr_reader :accelerator, :action_name, :direction, :subtitle, :title
    end
  end

  module Adw
    class ShortcutsSection < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel
      include GtkAst::Gtk::Buildable

      TYPE = "Adw.ShortcutsSection"
      GTYPE = "AdwShortcutsSection"
      FIELDS = [:item_type, :n_items, :title].freeze
      PROPERTIES = {item_type: "item-type", n_items: "n-items", title: "title"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + GtkAst::Gtk::Buildable::FIELDS + FIELDS).uniq.freeze

      attr_reader :item_type, :n_items, :title
    end
  end

  module Adw
    class Sidebar < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.Sidebar"
      GTYPE = "AdwSidebar"
      FIELDS = [:drop_preload, :filter, :items, :menu_model, :mode, :placeholder, :sections, :selected, :selected_item].freeze
      PROPERTIES = {drop_preload: "drop-preload", filter: "filter", items: "items", menu_model: "menu-model", mode: "mode", placeholder: "placeholder", sections: "sections", selected: "selected", selected_item: "selected-item"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      MODE_DOMAIN = [:sidebar, :page].freeze

      attr_reader :drop_preload, :filter, :items, :menu_model, :mode, :placeholder, :sections, :selected, :selected_item
    end
  end

  module Adw
    class SidebarItem < GtkAst::GObject::Object

      TYPE = "Adw.SidebarItem"
      GTYPE = "AdwSidebarItem"
      FIELDS = [:drag_motion_activate, :enabled, :icon_name, :icon_paintable, :section, :subtitle, :suffix, :title, :tooltip, :use_underline, :visible].freeze
      PROPERTIES = {drag_motion_activate: "drag-motion-activate", enabled: "enabled", icon_name: "icon-name", icon_paintable: "icon-paintable", section: "section", subtitle: "subtitle", suffix: "suffix", title: "title", tooltip: "tooltip", use_underline: "use-underline", visible: "visible"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :drag_motion_activate, :enabled, :icon_name, :icon_paintable, :section, :subtitle, :suffix, :title, :tooltip, :use_underline, :visible
    end
  end

  module Adw
    class SidebarSection < GtkAst::GObject::Object
      include GtkAst::Gtk::Buildable

      TYPE = "Adw.SidebarSection"
      GTYPE = "AdwSidebarSection"
      FIELDS = [:items, :menu_model, :sidebar, :title].freeze
      PROPERTIES = {items: "items", menu_model: "menu-model", sidebar: "sidebar", title: "title"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Buildable::FIELDS + FIELDS).uniq.freeze

      attr_reader :items, :menu_model, :sidebar, :title
    end
  end

  module Adw
    class SpinRow < ActionRow
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Actionable
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Editable

      TYPE = "Adw.SpinRow"
      GTYPE = "AdwSpinRow"
      FIELDS = [:adjustment, :climb_rate, :digits, :numeric, :snap_to_ticks, :update_policy, :value, :wrap].freeze
      PROPERTIES = {adjustment: "adjustment", climb_rate: "climb-rate", digits: "digits", numeric: "numeric", snap_to_ticks: "snap-to-ticks", update_policy: "update-policy", value: "value", wrap: "wrap"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Actionable::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Editable::FIELDS + FIELDS).uniq.freeze
      UPDATE_POLICY_DOMAIN = [:always, :if_valid].freeze

      attr_reader :adjustment, :climb_rate, :digits, :numeric, :snap_to_ticks, :update_policy, :value, :wrap
    end
  end

  module Adw
    class Spinner < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.Spinner"
      GTYPE = "AdwSpinner"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Adw
    class SpinnerPaintable < GtkAst::GObject::Object
      include GtkAst::Gdk::Paintable
      include GtkAst::Gtk::SymbolicPaintable

      TYPE = "Adw.SpinnerPaintable"
      GTYPE = "AdwSpinnerPaintable"
      FIELDS = [:widget].freeze
      PROPERTIES = {widget: "widget"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gdk::Paintable::FIELDS + GtkAst::Gtk::SymbolicPaintable::FIELDS + FIELDS).uniq.freeze

      attr_reader :widget
    end
  end

  module Adw
    class SplitButton < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Actionable
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.SplitButton"
      GTYPE = "AdwSplitButton"
      FIELDS = [:can_shrink, :child, :direction, :dropdown_tooltip, :icon_name, :label, :menu_model, :popover, :use_underline].freeze
      PROPERTIES = {can_shrink: "can-shrink", child: "child", direction: "direction", dropdown_tooltip: "dropdown-tooltip", icon_name: "icon-name", label: "label", menu_model: "menu-model", popover: "popover", use_underline: "use-underline"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Actionable::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      DIRECTION_DOMAIN = [:up, :down, :left, :right, :none].freeze

      attr_reader :can_shrink, :child, :direction, :dropdown_tooltip, :icon_name, :label, :menu_model, :popover, :use_underline
    end
  end

  module Adw
    class SpringAnimation < Animation

      TYPE = "Adw.SpringAnimation"
      GTYPE = "AdwSpringAnimation"
      FIELDS = [:clamp, :epsilon, :estimated_duration, :initial_velocity, :spring_params, :value_from, :value_to, :velocity].freeze
      PROPERTIES = {clamp: "clamp", epsilon: "epsilon", estimated_duration: "estimated-duration", initial_velocity: "initial-velocity", spring_params: "spring-params", value_from: "value-from", value_to: "value-to", velocity: "velocity"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :clamp, :epsilon, :estimated_duration, :initial_velocity, :spring_params, :value_from, :value_to, :velocity
    end
  end

  module Adw
    class Squeezer < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Orientable

      TYPE = "Adw.Squeezer"
      GTYPE = "AdwSqueezer"
      FIELDS = [:allow_none, :homogeneous, :interpolate_size, :pages, :switch_threshold_policy, :transition_duration, :transition_running, :transition_type, :visible_child, :xalign, :yalign].freeze
      PROPERTIES = {allow_none: "allow-none", homogeneous: "homogeneous", interpolate_size: "interpolate-size", pages: "pages", switch_threshold_policy: "switch-threshold-policy", transition_duration: "transition-duration", transition_running: "transition-running", transition_type: "transition-type", visible_child: "visible-child", xalign: "xalign", yalign: "yalign"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Orientable::FIELDS + FIELDS).uniq.freeze
      SWITCH_THRESHOLD_POLICY_DOMAIN = [:minimum, :natural].freeze
      TRANSITION_TYPE_DOMAIN = [:none, :crossfade].freeze

      attr_reader :allow_none, :homogeneous, :interpolate_size, :pages, :switch_threshold_policy, :transition_duration, :transition_running, :transition_type, :visible_child, :xalign, :yalign
    end
  end

  module Adw
    class SqueezerPage < GtkAst::GObject::Object

      TYPE = "Adw.SqueezerPage"
      GTYPE = "AdwSqueezerPage"
      FIELDS = [:child, :enabled].freeze
      PROPERTIES = {child: "child", enabled: "enabled"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :child, :enabled
    end
  end

  module Adw
    class StatusPage < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.StatusPage"
      GTYPE = "AdwStatusPage"
      FIELDS = [:child, :description, :icon_name, :paintable, :title].freeze
      PROPERTIES = {child: "child", description: "description", icon_name: "icon-name", paintable: "paintable", title: "title"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :child, :description, :icon_name, :paintable, :title
    end
  end

  module Adw
    class StyleManager < GtkAst::GObject::Object

      TYPE = "Adw.StyleManager"
      GTYPE = "AdwStyleManager"
      FIELDS = [:accent_color, :accent_color_rgba, :color_scheme, :dark, :display, :document_font_name, :high_contrast, :monospace_font_name, :system_supports_accent_colors, :system_supports_color_schemes].freeze
      PROPERTIES = {accent_color: "accent-color", accent_color_rgba: "accent-color-rgba", color_scheme: "color-scheme", dark: "dark", display: "display", document_font_name: "document-font-name", high_contrast: "high-contrast", monospace_font_name: "monospace-font-name", system_supports_accent_colors: "system-supports-accent-colors", system_supports_color_schemes: "system-supports-color-schemes"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      ACCENT_COLOR_DOMAIN = [:blue, :teal, :green, :yellow, :orange, :red, :pink, :purple, :slate].freeze
      COLOR_SCHEME_DOMAIN = [:default, :force_light, :prefer_light, :prefer_dark, :force_dark].freeze

      attr_reader :accent_color, :accent_color_rgba, :color_scheme, :dark, :display, :document_font_name, :high_contrast, :monospace_font_name, :system_supports_accent_colors, :system_supports_color_schemes
    end
  end

  module Adw
    class SwipeTracker < GtkAst::GObject::Object
      include GtkAst::Gtk::Orientable

      TYPE = "Adw.SwipeTracker"
      GTYPE = "AdwSwipeTracker"
      FIELDS = [:allow_long_swipes, :allow_mouse_drag, :allow_window_handle, :enabled, :lower_overshoot, :reversed, :swipeable, :upper_overshoot].freeze
      PROPERTIES = {allow_long_swipes: "allow-long-swipes", allow_mouse_drag: "allow-mouse-drag", allow_window_handle: "allow-window-handle", enabled: "enabled", lower_overshoot: "lower-overshoot", reversed: "reversed", swipeable: "swipeable", upper_overshoot: "upper-overshoot"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :allow_long_swipes, :allow_mouse_drag, :allow_window_handle, :enabled, :lower_overshoot, :reversed, :swipeable, :upper_overshoot
    end
  end

  module Adw
    class SwitchRow < ActionRow
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Actionable
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.SwitchRow"
      GTYPE = "AdwSwitchRow"
      FIELDS = [:active].freeze
      PROPERTIES = {active: "active"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Actionable::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :active
    end
  end

  module Adw
    class TabBar < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.TabBar"
      GTYPE = "AdwTabBar"
      FIELDS = [:autohide, :end_action_widget, :expand_tabs, :extra_drag_preferred_action, :extra_drag_preload, :inverted, :is_overflowing, :start_action_widget, :tabs_revealed, :view].freeze
      PROPERTIES = {autohide: "autohide", end_action_widget: "end-action-widget", expand_tabs: "expand-tabs", extra_drag_preferred_action: "extra-drag-preferred-action", extra_drag_preload: "extra-drag-preload", inverted: "inverted", is_overflowing: "is-overflowing", start_action_widget: "start-action-widget", tabs_revealed: "tabs-revealed", view: "view"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      EXTRA_DRAG_PREFERRED_ACTION_DOMAIN = [:none, :copy, :move, :link, :ask].freeze

      attr_reader :autohide, :end_action_widget, :expand_tabs, :extra_drag_preferred_action, :extra_drag_preload, :inverted, :is_overflowing, :start_action_widget, :tabs_revealed, :view
    end
  end

  module Adw
    class TabButton < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Actionable
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.TabButton"
      GTYPE = "AdwTabButton"
      FIELDS = [:view].freeze
      PROPERTIES = {view: "view"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Actionable::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :view
    end
  end

  module Adw
    class TabOverview < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.TabOverview"
      GTYPE = "AdwTabOverview"
      FIELDS = [:child, :enable_new_tab, :enable_search, :extra_drag_preferred_action, :extra_drag_preload, :inverted, :open, :search_active, :secondary_menu, :show_end_title_buttons, :show_start_title_buttons, :view].freeze
      PROPERTIES = {child: "child", enable_new_tab: "enable-new-tab", enable_search: "enable-search", extra_drag_preferred_action: "extra-drag-preferred-action", extra_drag_preload: "extra-drag-preload", inverted: "inverted", open: "open", search_active: "search-active", secondary_menu: "secondary-menu", show_end_title_buttons: "show-end-title-buttons", show_start_title_buttons: "show-start-title-buttons", view: "view"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      EXTRA_DRAG_PREFERRED_ACTION_DOMAIN = [:none, :copy, :move, :link, :ask].freeze

      attr_reader :child, :enable_new_tab, :enable_search, :extra_drag_preferred_action, :extra_drag_preload, :inverted, :open, :search_active, :secondary_menu, :show_end_title_buttons, :show_start_title_buttons, :view
    end
  end

  module Adw
    class TabPage < GtkAst::GObject::Object
      include GtkAst::Gtk::Accessible

      TYPE = "Adw.TabPage"
      GTYPE = "AdwTabPage"
      FIELDS = [:child, :icon, :indicator_activatable, :indicator_icon, :indicator_tooltip, :keyword, :live_thumbnail, :loading, :needs_attention, :parent, :pinned, :selected, :thumbnail_xalign, :thumbnail_yalign, :title, :tooltip].freeze
      PROPERTIES = {child: "child", icon: "icon", indicator_activatable: "indicator-activatable", indicator_icon: "indicator-icon", indicator_tooltip: "indicator-tooltip", keyword: "keyword", live_thumbnail: "live-thumbnail", loading: "loading", needs_attention: "needs-attention", parent: "parent", pinned: "pinned", selected: "selected", thumbnail_xalign: "thumbnail-xalign", thumbnail_yalign: "thumbnail-yalign", title: "title", tooltip: "tooltip"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + FIELDS).uniq.freeze

      attr_reader :child, :icon, :indicator_activatable, :indicator_icon, :indicator_tooltip, :keyword, :live_thumbnail, :loading, :needs_attention, :parent, :pinned, :selected, :thumbnail_xalign, :thumbnail_yalign, :title, :tooltip
    end
  end

  module Adw
    class TabView < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.TabView"
      GTYPE = "AdwTabView"
      FIELDS = [:default_icon, :is_transferring_page, :menu_model, :n_pages, :n_pinned_pages, :pages, :selected_page, :shortcuts].freeze
      PROPERTIES = {default_icon: "default-icon", is_transferring_page: "is-transferring-page", menu_model: "menu-model", n_pages: "n-pages", n_pinned_pages: "n-pinned-pages", pages: "pages", selected_page: "selected-page", shortcuts: "shortcuts"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      SHORTCUTS_DOMAIN = [:none, :control_tab, :control_shift_tab, :control_page_up, :control_page_down, :control_home, :control_end, :control_shift_page_up, :control_shift_page_down, :control_shift_home, :control_shift_end, :alt_digits, :alt_zero, :all_shortcuts].freeze

      attr_reader :default_icon, :is_transferring_page, :menu_model, :n_pages, :n_pinned_pages, :pages, :selected_page, :shortcuts
    end
  end

  module Adw
    class TimedAnimation < Animation

      TYPE = "Adw.TimedAnimation"
      GTYPE = "AdwTimedAnimation"
      FIELDS = [:alternate, :duration, :easing, :repeat_count, :reverse, :value_from, :value_to].freeze
      PROPERTIES = {alternate: "alternate", duration: "duration", easing: "easing", repeat_count: "repeat-count", reverse: "reverse", value_from: "value-from", value_to: "value-to"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      EASING_DOMAIN = [:linear, :ease_in_quad, :ease_out_quad, :ease_in_out_quad, :ease_in_cubic, :ease_out_cubic, :ease_in_out_cubic, :ease_in_quart, :ease_out_quart, :ease_in_out_quart, :ease_in_quint, :ease_out_quint, :ease_in_out_quint, :ease_in_sine, :ease_out_sine, :ease_in_out_sine, :ease_in_expo, :ease_out_expo, :ease_in_out_expo, :ease_in_circ, :ease_out_circ, :ease_in_out_circ, :ease_in_elastic, :ease_out_elastic, :ease_in_out_elastic, :ease_in_back, :ease_out_back, :ease_in_out_back, :ease_in_bounce, :ease_out_bounce, :ease_in_out_bounce, :ease, :ease_in, :ease_out, :ease_in_out].freeze

      attr_reader :alternate, :duration, :easing, :repeat_count, :reverse, :value_from, :value_to
    end
  end

  module Adw
    class Toast < GtkAst::GObject::Object

      TYPE = "Adw.Toast"
      GTYPE = "AdwToast"
      FIELDS = [:action_name, :action_target, :button_label, :custom_title, :priority, :timeout, :title, :use_markup].freeze
      PROPERTIES = {action_name: "action-name", action_target: "action-target", button_label: "button-label", custom_title: "custom-title", priority: "priority", timeout: "timeout", title: "title", use_markup: "use-markup"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      PRIORITY_DOMAIN = [:normal, :high].freeze

      attr_reader :action_name, :action_target, :button_label, :custom_title, :priority, :timeout, :title, :use_markup
    end
  end

  module Adw
    class ToastOverlay < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.ToastOverlay"
      GTYPE = "AdwToastOverlay"
      FIELDS = [:child].freeze
      PROPERTIES = {child: "child"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :child
    end
  end

  module Adw
    class Toggle < GtkAst::GObject::Object

      TYPE = "Adw.Toggle"
      GTYPE = "AdwToggle"
      FIELDS = [:child, :description, :enabled, :icon_name, :label, :name, :tooltip, :use_underline].freeze
      PROPERTIES = {child: "child", description: "description", enabled: "enabled", icon_name: "icon-name", label: "label", name: "name", tooltip: "tooltip", use_underline: "use-underline"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :child, :description, :enabled, :icon_name, :label, :name, :tooltip, :use_underline
    end
  end

  module Adw
    class ToggleGroup < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Orientable

      TYPE = "Adw.ToggleGroup"
      GTYPE = "AdwToggleGroup"
      FIELDS = [:active, :active_name, :can_shrink, :homogeneous, :n_toggles, :toggles].freeze
      PROPERTIES = {active: "active", active_name: "active-name", can_shrink: "can-shrink", homogeneous: "homogeneous", n_toggles: "n-toggles", toggles: "toggles"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :active, :active_name, :can_shrink, :homogeneous, :n_toggles, :toggles
    end
  end

  module Adw
    class ToolbarView < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.ToolbarView"
      GTYPE = "AdwToolbarView"
      FIELDS = [:bottom_bar_height, :bottom_bar_style, :content, :extend_content_to_bottom_edge, :extend_content_to_top_edge, :reveal_bottom_bars, :reveal_top_bars, :top_bar_height, :top_bar_style].freeze
      PROPERTIES = {bottom_bar_height: "bottom-bar-height", bottom_bar_style: "bottom-bar-style", content: "content", extend_content_to_bottom_edge: "extend-content-to-bottom-edge", extend_content_to_top_edge: "extend-content-to-top-edge", reveal_bottom_bars: "reveal-bottom-bars", reveal_top_bars: "reveal-top-bars", top_bar_height: "top-bar-height", top_bar_style: "top-bar-style"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      BOTTOM_BAR_STYLE_DOMAIN = [:flat, :raised, :raised_border].freeze
      TOP_BAR_STYLE_DOMAIN = [:flat, :raised, :raised_border].freeze

      attr_reader :bottom_bar_height, :bottom_bar_style, :content, :extend_content_to_bottom_edge, :extend_content_to_top_edge, :reveal_bottom_bars, :reveal_top_bars, :top_bar_height, :top_bar_style
    end
  end

  module Adw
    class ViewStack < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.ViewStack"
      GTYPE = "AdwViewStack"
      FIELDS = [:enable_transitions, :hhomogeneous, :pages, :transition_duration, :transition_running, :vhomogeneous, :visible_child, :visible_child_name].freeze
      PROPERTIES = {enable_transitions: "enable-transitions", hhomogeneous: "hhomogeneous", pages: "pages", transition_duration: "transition-duration", transition_running: "transition-running", vhomogeneous: "vhomogeneous", visible_child: "visible-child", visible_child_name: "visible-child-name"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :enable_transitions, :hhomogeneous, :pages, :transition_duration, :transition_running, :vhomogeneous, :visible_child, :visible_child_name
    end
  end

  module Adw
    class ViewStackPage < GtkAst::GObject::Object
      include GtkAst::Gtk::Accessible

      TYPE = "Adw.ViewStackPage"
      GTYPE = "AdwViewStackPage"
      FIELDS = [:badge_number, :child, :icon_name, :name, :needs_attention, :section_title, :starts_section, :title, :use_underline, :visible].freeze
      PROPERTIES = {badge_number: "badge-number", child: "child", icon_name: "icon-name", name: "name", needs_attention: "needs-attention", section_title: "section-title", starts_section: "starts-section", title: "title", use_underline: "use-underline", visible: "visible"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + FIELDS).uniq.freeze

      attr_reader :badge_number, :child, :icon_name, :name, :needs_attention, :section_title, :starts_section, :title, :use_underline, :visible
    end
  end

  module Adw
    class ViewStackPages < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel
      include GtkAst::Gtk::SectionModel
      include GtkAst::Gtk::SelectionModel

      TYPE = "Adw.ViewStackPages"
      GTYPE = "AdwViewStackPages"
      FIELDS = [:item_type, :n_items, :selected_page].freeze
      PROPERTIES = {item_type: "item-type", n_items: "n-items", selected_page: "selected-page"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + GtkAst::Gtk::SectionModel::FIELDS + GtkAst::Gtk::SelectionModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :item_type, :n_items, :selected_page
    end
  end

  module Adw
    class ViewSwitcher < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.ViewSwitcher"
      GTYPE = "AdwViewSwitcher"
      FIELDS = [:policy, :stack].freeze
      PROPERTIES = {policy: "policy", stack: "stack"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      POLICY_DOMAIN = [:narrow, :wide].freeze

      attr_reader :policy, :stack
    end
  end

  module Adw
    class ViewSwitcherBar < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.ViewSwitcherBar"
      GTYPE = "AdwViewSwitcherBar"
      FIELDS = [:reveal, :stack].freeze
      PROPERTIES = {reveal: "reveal", stack: "stack"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :reveal, :stack
    end
  end

  module Adw
    class ViewSwitcherSidebar < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.ViewSwitcherSidebar"
      GTYPE = "AdwViewSwitcherSidebar"
      FIELDS = [:filter, :mode, :placeholder, :stack].freeze
      PROPERTIES = {filter: "filter", mode: "mode", placeholder: "placeholder", stack: "stack"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      MODE_DOMAIN = [:sidebar, :page].freeze

      attr_reader :filter, :mode, :placeholder, :stack
    end
  end

  module Adw
    class ViewSwitcherTitle < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.ViewSwitcherTitle"
      GTYPE = "AdwViewSwitcherTitle"
      FIELDS = [:stack, :subtitle, :title, :title_visible, :view_switcher_enabled].freeze
      PROPERTIES = {stack: "stack", subtitle: "subtitle", title: "title", title_visible: "title-visible", view_switcher_enabled: "view-switcher-enabled"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :stack, :subtitle, :title, :title_visible, :view_switcher_enabled
    end
  end

  module Adw
    class WindowTitle < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget

      TYPE = "Adw.WindowTitle"
      GTYPE = "AdwWindowTitle"
      FIELDS = [:subtitle, :title].freeze
      PROPERTIES = {subtitle: "subtitle", title: "title"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :subtitle, :title
    end
  end

  module Adw
    class WrapBox < GtkAst::Gtk::Widget
      include GtkAst::Gtk::Accessible
      include GtkAst::Gtk::Buildable
      include GtkAst::Gtk::ConstraintTarget
      include GtkAst::Gtk::Orientable

      TYPE = "Adw.WrapBox"
      GTYPE = "AdwWrapBox"
      FIELDS = [:align, :child_spacing, :child_spacing_unit, :justify, :justify_last_line, :line_homogeneous, :line_spacing, :line_spacing_unit, :natural_line_length, :natural_line_length_unit, :pack_direction, :wrap_policy, :wrap_reverse].freeze
      PROPERTIES = {align: "align", child_spacing: "child-spacing", child_spacing_unit: "child-spacing-unit", justify: "justify", justify_last_line: "justify-last-line", line_homogeneous: "line-homogeneous", line_spacing: "line-spacing", line_spacing_unit: "line-spacing-unit", natural_line_length: "natural-line-length", natural_line_length_unit: "natural-line-length-unit", pack_direction: "pack-direction", wrap_policy: "wrap-policy", wrap_reverse: "wrap-reverse"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Accessible::FIELDS + GtkAst::Gtk::Buildable::FIELDS + GtkAst::Gtk::ConstraintTarget::FIELDS + GtkAst::Gtk::Orientable::FIELDS + FIELDS).uniq.freeze
      CHILD_SPACING_UNIT_DOMAIN = [:px, :pt, :sp].freeze
      JUSTIFY_DOMAIN = [:none, :fill, :spread].freeze
      LINE_SPACING_UNIT_DOMAIN = [:px, :pt, :sp].freeze
      NATURAL_LINE_LENGTH_UNIT_DOMAIN = [:px, :pt, :sp].freeze
      PACK_DIRECTION_DOMAIN = [:start_to_end, :end_to_start].freeze
      WRAP_POLICY_DOMAIN = [:minimum, :natural].freeze

      attr_reader :align, :child_spacing, :child_spacing_unit, :justify, :justify_last_line, :line_homogeneous, :line_spacing, :line_spacing_unit, :natural_line_length, :natural_line_length_unit, :pack_direction, :wrap_policy, :wrap_reverse
    end
  end

  module Adw
    class WrapLayout < GtkAst::Gtk::LayoutManager
      include GtkAst::Gtk::Orientable

      TYPE = "Adw.WrapLayout"
      GTYPE = "AdwWrapLayout"
      FIELDS = [:align, :child_spacing, :child_spacing_unit, :justify, :justify_last_line, :line_homogeneous, :line_spacing, :line_spacing_unit, :natural_line_length, :natural_line_length_unit, :pack_direction, :wrap_policy, :wrap_reverse].freeze
      PROPERTIES = {align: "align", child_spacing: "child-spacing", child_spacing_unit: "child-spacing-unit", justify: "justify", justify_last_line: "justify-last-line", line_homogeneous: "line-homogeneous", line_spacing: "line-spacing", line_spacing_unit: "line-spacing-unit", natural_line_length: "natural-line-length", natural_line_length_unit: "natural-line-length-unit", pack_direction: "pack-direction", wrap_policy: "wrap-policy", wrap_reverse: "wrap-reverse"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gtk::Orientable::FIELDS + FIELDS).uniq.freeze
      CHILD_SPACING_UNIT_DOMAIN = [:px, :pt, :sp].freeze
      JUSTIFY_DOMAIN = [:none, :fill, :spread].freeze
      LINE_SPACING_UNIT_DOMAIN = [:px, :pt, :sp].freeze
      NATURAL_LINE_LENGTH_UNIT_DOMAIN = [:px, :pt, :sp].freeze
      PACK_DIRECTION_DOMAIN = [:start_to_end, :end_to_start].freeze
      WRAP_POLICY_DOMAIN = [:minimum, :natural].freeze

      attr_reader :align, :child_spacing, :child_spacing_unit, :justify, :justify_last_line, :line_homogeneous, :line_spacing, :line_spacing_unit, :natural_line_length, :natural_line_length_unit, :pack_direction, :wrap_policy, :wrap_reverse
    end
  end

  module GObject
    class Binding < Object

      TYPE = "GObject.Binding"
      GTYPE = "GBinding"
      FIELDS = [:flags, :source, :source_property, :target, :target_property].freeze
      PROPERTIES = {flags: "flags", source: "source", source_property: "source-property", target: "target", target_property: "target-property"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      FLAGS_DOMAIN = [:default, :bidirectional, :sync_create, :invert_boolean].freeze

      attr_reader :flags, :source, :source_property, :target, :target_property
    end
  end

  module GObject
    class BindingGroup < Object

      TYPE = "GObject.BindingGroup"
      GTYPE = "GBindingGroup"
      FIELDS = [:source].freeze
      PROPERTIES = {source: "source"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :source
    end
  end

  module GObject
    class ParamSpec < GtkAst::Node

      TYPE = "GObject.ParamSpec"
      GTYPE = "GParam"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecBoolean < ParamSpec

      TYPE = "GObject.ParamSpecBoolean"
      GTYPE = "GParamBoolean"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecBoxed < ParamSpec

      TYPE = "GObject.ParamSpecBoxed"
      GTYPE = "GParamBoxed"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecChar < ParamSpec

      TYPE = "GObject.ParamSpecChar"
      GTYPE = "GParamChar"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecDouble < ParamSpec

      TYPE = "GObject.ParamSpecDouble"
      GTYPE = "GParamDouble"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecEnum < ParamSpec

      TYPE = "GObject.ParamSpecEnum"
      GTYPE = "GParamEnum"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecFlags < ParamSpec

      TYPE = "GObject.ParamSpecFlags"
      GTYPE = "GParamFlags"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecFloat < ParamSpec

      TYPE = "GObject.ParamSpecFloat"
      GTYPE = "GParamFloat"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecGType < ParamSpec

      TYPE = "GObject.ParamSpecGType"
      GTYPE = "GParamGType"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecInt < ParamSpec

      TYPE = "GObject.ParamSpecInt"
      GTYPE = "GParamInt"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecInt64 < ParamSpec

      TYPE = "GObject.ParamSpecInt64"
      GTYPE = "GParamInt64"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecLong < ParamSpec

      TYPE = "GObject.ParamSpecLong"
      GTYPE = "GParamLong"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecObject < ParamSpec

      TYPE = "GObject.ParamSpecObject"
      GTYPE = "GParamObject"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecOverride < ParamSpec

      TYPE = "GObject.ParamSpecOverride"
      GTYPE = "GParamOverride"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecParam < ParamSpec

      TYPE = "GObject.ParamSpecParam"
      GTYPE = "GParamParam"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecPointer < ParamSpec

      TYPE = "GObject.ParamSpecPointer"
      GTYPE = "GParamPointer"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecString < ParamSpec

      TYPE = "GObject.ParamSpecString"
      GTYPE = "GParamString"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecUChar < ParamSpec

      TYPE = "GObject.ParamSpecUChar"
      GTYPE = "GParamUChar"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecUInt < ParamSpec

      TYPE = "GObject.ParamSpecUInt"
      GTYPE = "GParamUInt"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecUInt64 < ParamSpec

      TYPE = "GObject.ParamSpecUInt64"
      GTYPE = "GParamUInt64"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecULong < ParamSpec

      TYPE = "GObject.ParamSpecULong"
      GTYPE = "GParamULong"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecUnichar < ParamSpec

      TYPE = "GObject.ParamSpecUnichar"
      GTYPE = "GParamUnichar"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecValueArray < ParamSpec

      TYPE = "GObject.ParamSpecValueArray"
      GTYPE = "GParamValueArray"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class ParamSpecVariant < ParamSpec

      TYPE = "GObject.ParamSpecVariant"
      GTYPE = "GParamVariant"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GObject
    class SignalGroup < Object

      TYPE = "GObject.SignalGroup"
      GTYPE = "GSignalGroup"
      FIELDS = [:target, :target_type].freeze
      PROPERTIES = {target: "target", target_type: "target-type"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :target, :target_type
    end
  end

  module GObject
    class TypeModule < Object
      include TypePlugin

      TYPE = "GObject.TypeModule"
      GTYPE = "GTypeModule"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + TypePlugin::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class AppLaunchContext < GtkAst::GObject::Object

      TYPE = "Gio.AppLaunchContext"
      GTYPE = "GAppLaunchContext"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class AppLaunchContext < GtkAst::Gio::AppLaunchContext

      TYPE = "Gdk.AppLaunchContext"
      GTYPE = "GdkAppLaunchContext"
      FIELDS = [:display].freeze
      PROPERTIES = {display: "display"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :display
    end
  end

  module Gdk
    class Event < GtkAst::Node

      TYPE = "Gdk.Event"
      GTYPE = "GdkEvent"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class ButtonEvent < Event

      TYPE = "Gdk.ButtonEvent"
      GTYPE = "GdkButtonEvent"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class DrawContext < GtkAst::GObject::Object

      TYPE = "Gdk.DrawContext"
      GTYPE = "GdkDrawContext"
      FIELDS = [:display, :surface].freeze
      PROPERTIES = {display: "display", surface: "surface"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :display, :surface
    end
  end

  module Gdk
    class CairoContext < DrawContext

      TYPE = "Gdk.CairoContext"
      GTYPE = "GdkCairoContext"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class CicpParams < GtkAst::GObject::Object

      TYPE = "Gdk.CicpParams"
      GTYPE = "GdkCicpParams"
      FIELDS = [:color_primaries, :matrix_coefficients, :range, :transfer_function].freeze
      PROPERTIES = {color_primaries: "color-primaries", matrix_coefficients: "matrix-coefficients", range: "range", transfer_function: "transfer-function"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      RANGE_DOMAIN = [:narrow, :full].freeze

      attr_reader :color_primaries, :matrix_coefficients, :range, :transfer_function
    end
  end

  module Gdk
    class Clipboard < GtkAst::GObject::Object

      TYPE = "Gdk.Clipboard"
      GTYPE = "GdkClipboard"
      FIELDS = [:content, :display, :formats, :local].freeze
      PROPERTIES = {content: "content", display: "display", formats: "formats", local: "local"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :content, :display, :formats, :local
    end
  end

  module Gdk
    class ContentDeserializer < GtkAst::GObject::Object
      include GtkAst::Gio::AsyncResult

      TYPE = "Gdk.ContentDeserializer"
      GTYPE = "GdkContentDeserializer"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::AsyncResult::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class ContentProvider < GtkAst::GObject::Object

      TYPE = "Gdk.ContentProvider"
      GTYPE = "GdkContentProvider"
      FIELDS = [:formats, :storable_formats].freeze
      PROPERTIES = {formats: "formats", storable_formats: "storable-formats"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :formats, :storable_formats
    end
  end

  module Gdk
    class ContentSerializer < GtkAst::GObject::Object
      include GtkAst::Gio::AsyncResult

      TYPE = "Gdk.ContentSerializer"
      GTYPE = "GdkContentSerializer"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::AsyncResult::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class CrossingEvent < Event

      TYPE = "Gdk.CrossingEvent"
      GTYPE = "GdkCrossingEvent"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class Cursor < GtkAst::GObject::Object

      TYPE = "Gdk.Cursor"
      GTYPE = "GdkCursor"
      FIELDS = [:fallback, :hotspot_x, :hotspot_y, :name, :texture].freeze
      PROPERTIES = {fallback: "fallback", hotspot_x: "hotspot-x", hotspot_y: "hotspot-y", name: "name", texture: "texture"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :fallback, :hotspot_x, :hotspot_y, :name, :texture
    end
  end

  module Gdk
    class DNDEvent < Event

      TYPE = "Gdk.DNDEvent"
      GTYPE = "GdkDNDEvent"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class DeleteEvent < Event

      TYPE = "Gdk.DeleteEvent"
      GTYPE = "GdkDeleteEvent"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class DeviceTool < GtkAst::GObject::Object

      TYPE = "Gdk.DeviceTool"
      GTYPE = "GdkDeviceTool"
      FIELDS = [:axes, :hardware_id, :serial, :tool_type].freeze
      PROPERTIES = {axes: "axes", hardware_id: "hardware-id", serial: "serial", tool_type: "tool-type"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      AXES_DOMAIN = [:x, :y, :delta_x, :delta_y, :pressure, :xtilt, :ytilt, :wheel, :distance, :rotation, :slider].freeze
      TOOL_TYPE_DOMAIN = [:unknown, :pen, :eraser, :brush, :pencil, :airbrush, :mouse, :lens].freeze

      attr_reader :axes, :hardware_id, :serial, :tool_type
    end
  end

  module Gdk
    class Display < GtkAst::GObject::Object

      TYPE = "Gdk.Display"
      GTYPE = "GdkDisplay"
      FIELDS = [:composited, :dmabuf_formats, :input_shapes, :rgba, :shadow_width].freeze
      PROPERTIES = {composited: "composited", dmabuf_formats: "dmabuf-formats", input_shapes: "input-shapes", rgba: "rgba", shadow_width: "shadow-width"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :composited, :dmabuf_formats, :input_shapes, :rgba, :shadow_width
    end
  end

  module Gdk
    class DisplayManager < GtkAst::GObject::Object

      TYPE = "Gdk.DisplayManager"
      GTYPE = "GdkDisplayManager"
      FIELDS = [:default_display].freeze
      PROPERTIES = {default_display: "default-display"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :default_display
    end
  end

  module Gdk
    class Texture < GtkAst::GObject::Object
      include Paintable
      include GtkAst::Gio::Icon
      include GtkAst::Gio::LoadableIcon

      TYPE = "Gdk.Texture"
      GTYPE = "GdkTexture"
      FIELDS = [:color_state, :height, :width].freeze
      PROPERTIES = {color_state: "color-state", height: "height", width: "width"}.freeze
      KEYS = (superclass::KEYS + Paintable::FIELDS + GtkAst::Gio::Icon::FIELDS + GtkAst::Gio::LoadableIcon::FIELDS + FIELDS).uniq.freeze

      attr_reader :color_state, :height, :width
    end
  end

  module Gdk
    class DmabufTexture < Texture
      include Paintable
      include GtkAst::Gio::Icon
      include GtkAst::Gio::LoadableIcon

      TYPE = "Gdk.DmabufTexture"
      GTYPE = "GdkDmabufTexture"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Paintable::FIELDS + GtkAst::Gio::Icon::FIELDS + GtkAst::Gio::LoadableIcon::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class DmabufTextureBuilder < GtkAst::GObject::Object

      TYPE = "Gdk.DmabufTextureBuilder"
      GTYPE = "GdkDmabufTextureBuilder"
      FIELDS = [:color_state, :display, :fourcc, :height, :modifier, :n_planes, :premultiplied, :update_region, :update_texture, :width].freeze
      PROPERTIES = {color_state: "color-state", display: "display", fourcc: "fourcc", height: "height", modifier: "modifier", n_planes: "n-planes", premultiplied: "premultiplied", update_region: "update-region", update_texture: "update-texture", width: "width"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :color_state, :display, :fourcc, :height, :modifier, :n_planes, :premultiplied, :update_region, :update_texture, :width
    end
  end

  module Gdk
    class Drag < GtkAst::GObject::Object

      TYPE = "Gdk.Drag"
      GTYPE = "GdkDrag"
      FIELDS = [:actions, :content, :device, :display, :formats, :selected_action, :surface].freeze
      PROPERTIES = {actions: "actions", content: "content", device: "device", display: "display", formats: "formats", selected_action: "selected-action", surface: "surface"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      ACTIONS_DOMAIN = [:none, :copy, :move, :link, :ask].freeze
      SELECTED_ACTION_DOMAIN = [:none, :copy, :move, :link, :ask].freeze

      attr_reader :actions, :content, :device, :display, :formats, :selected_action, :surface
    end
  end

  module Gdk
    class Drop < GtkAst::GObject::Object

      TYPE = "Gdk.Drop"
      GTYPE = "GdkDrop"
      FIELDS = [:actions, :device, :display, :drag, :formats, :surface].freeze
      PROPERTIES = {actions: "actions", device: "device", display: "display", drag: "drag", formats: "formats", surface: "surface"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      ACTIONS_DOMAIN = [:none, :copy, :move, :link, :ask].freeze

      attr_reader :actions, :device, :display, :drag, :formats, :surface
    end
  end

  module Gdk
    class FocusEvent < Event

      TYPE = "Gdk.FocusEvent"
      GTYPE = "GdkFocusEvent"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class FrameClock < GtkAst::GObject::Object

      TYPE = "Gdk.FrameClock"
      GTYPE = "GdkFrameClock"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class GLContext < DrawContext

      TYPE = "Gdk.GLContext"
      GTYPE = "GdkGLContext"
      FIELDS = [:allowed_apis, :api, :shared_context].freeze
      PROPERTIES = {allowed_apis: "allowed-apis", api: "api", shared_context: "shared-context"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      ALLOWED_APIS_DOMAIN = [:gl, :gles].freeze
      API_DOMAIN = [:gl, :gles].freeze

      attr_reader :allowed_apis, :api, :shared_context
    end
  end

  module Gdk
    class GLTexture < Texture
      include Paintable
      include GtkAst::Gio::Icon
      include GtkAst::Gio::LoadableIcon

      TYPE = "Gdk.GLTexture"
      GTYPE = "GdkGLTexture"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Paintable::FIELDS + GtkAst::Gio::Icon::FIELDS + GtkAst::Gio::LoadableIcon::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class GLTextureBuilder < GtkAst::GObject::Object

      TYPE = "Gdk.GLTextureBuilder"
      GTYPE = "GdkGLTextureBuilder"
      FIELDS = [:color_state, :context, :format, :has_mipmap, :height, :id, :sync, :update_region, :update_texture, :width].freeze
      PROPERTIES = {color_state: "color-state", context: "context", format: "format", has_mipmap: "has-mipmap", height: "height", id: "id", sync: "sync", update_region: "update-region", update_texture: "update-texture", width: "width"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      FORMAT_DOMAIN = [:b8g8r8a8_premultiplied, :a8r8g8b8_premultiplied, :r8g8b8a8_premultiplied, :b8g8r8a8, :a8r8g8b8, :r8g8b8a8, :a8b8g8r8, :r8g8b8, :b8g8r8, :r16g16b16, :r16g16b16a16_premultiplied, :r16g16b16a16, :r16g16b16_float, :r16g16b16a16_float_premultiplied, :r16g16b16a16_float, :r32g32b32_float, :r32g32b32a32_float_premultiplied, :r32g32b32a32_float, :g8a8_premultiplied, :g8a8, :g8, :g16a16_premultiplied, :g16a16, :g16, :a8, :a16, :a16_float, :a32_float, :a8b8g8r8_premultiplied, :b8g8r8x8, :x8r8g8b8, :r8g8b8x8, :x8b8g8r8, :g8_b8r8_420, :g8_r8b8_420, :g8_b8r8_422, :g8_r8b8_422, :g8_b8r8_444, :g8_r8b8_444, :g10x6_b10x6r10x6_420, :g12x4_b12x4r12x4_420, :g16_b16r16_420, :g8_b8_r8_410, :g8_r8_b8_410, :g8_b8_r8_411, :g8_r8_b8_411, :g8_b8_r8_420, :g8_r8_b8_420, :g8_b8_r8_422, :g8_r8_b8_422, :g8_b8_r8_444, :g8_r8_b8_444, :g8b8g8r8_422, :g8r8g8b8_422, :r8g8b8g8_422, :b8g8r8g8_422, :x6g10_x6b10_x6r10_420, :x6g10_x6b10_x6r10_422, :x6g10_x6b10_x6r10_444, :x4g12_x4b12_x4r12_420, :x4g12_x4b12_x4r12_422, :x4g12_x4b12_x4r12_444, :g16_b16_r16_420, :g16_b16_r16_422, :g16_b16_r16_444, :n_formats].freeze

      attr_reader :color_state, :context, :format, :has_mipmap, :height, :id, :sync, :update_region, :update_texture, :width
    end
  end

  module Gdk
    class GrabBrokenEvent < Event

      TYPE = "Gdk.GrabBrokenEvent"
      GTYPE = "GdkGrabBrokenEvent"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class KeyEvent < Event

      TYPE = "Gdk.KeyEvent"
      GTYPE = "GdkKeyEvent"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class MemoryTexture < Texture
      include Paintable
      include GtkAst::Gio::Icon
      include GtkAst::Gio::LoadableIcon

      TYPE = "Gdk.MemoryTexture"
      GTYPE = "GdkMemoryTexture"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Paintable::FIELDS + GtkAst::Gio::Icon::FIELDS + GtkAst::Gio::LoadableIcon::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class MemoryTextureBuilder < GtkAst::GObject::Object

      TYPE = "Gdk.MemoryTextureBuilder"
      GTYPE = "GdkMemoryTextureBuilder"
      FIELDS = [:bytes, :color_state, :format, :height, :stride, :update_region, :update_texture, :width].freeze
      PROPERTIES = {bytes: "bytes", color_state: "color-state", format: "format", height: "height", stride: "stride", update_region: "update-region", update_texture: "update-texture", width: "width"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      FORMAT_DOMAIN = [:b8g8r8a8_premultiplied, :a8r8g8b8_premultiplied, :r8g8b8a8_premultiplied, :b8g8r8a8, :a8r8g8b8, :r8g8b8a8, :a8b8g8r8, :r8g8b8, :b8g8r8, :r16g16b16, :r16g16b16a16_premultiplied, :r16g16b16a16, :r16g16b16_float, :r16g16b16a16_float_premultiplied, :r16g16b16a16_float, :r32g32b32_float, :r32g32b32a32_float_premultiplied, :r32g32b32a32_float, :g8a8_premultiplied, :g8a8, :g8, :g16a16_premultiplied, :g16a16, :g16, :a8, :a16, :a16_float, :a32_float, :a8b8g8r8_premultiplied, :b8g8r8x8, :x8r8g8b8, :r8g8b8x8, :x8b8g8r8, :g8_b8r8_420, :g8_r8b8_420, :g8_b8r8_422, :g8_r8b8_422, :g8_b8r8_444, :g8_r8b8_444, :g10x6_b10x6r10x6_420, :g12x4_b12x4r12x4_420, :g16_b16r16_420, :g8_b8_r8_410, :g8_r8_b8_410, :g8_b8_r8_411, :g8_r8_b8_411, :g8_b8_r8_420, :g8_r8_b8_420, :g8_b8_r8_422, :g8_r8_b8_422, :g8_b8_r8_444, :g8_r8_b8_444, :g8b8g8r8_422, :g8r8g8b8_422, :r8g8b8g8_422, :b8g8r8g8_422, :x6g10_x6b10_x6r10_420, :x6g10_x6b10_x6r10_422, :x6g10_x6b10_x6r10_444, :x4g12_x4b12_x4r12_420, :x4g12_x4b12_x4r12_422, :x4g12_x4b12_x4r12_444, :g16_b16_r16_420, :g16_b16_r16_422, :g16_b16_r16_444, :n_formats].freeze

      attr_reader :bytes, :color_state, :format, :height, :stride, :update_region, :update_texture, :width
    end
  end

  module Gdk
    class Monitor < GtkAst::GObject::Object

      TYPE = "Gdk.Monitor"
      GTYPE = "GdkMonitor"
      FIELDS = [:connector, :description, :display, :geometry, :height_mm, :manufacturer, :model, :refresh_rate, :scale, :scale_factor, :subpixel_layout, :valid, :width_mm].freeze
      PROPERTIES = {connector: "connector", description: "description", display: "display", geometry: "geometry", height_mm: "height-mm", manufacturer: "manufacturer", model: "model", refresh_rate: "refresh-rate", scale: "scale", scale_factor: "scale-factor", subpixel_layout: "subpixel-layout", valid: "valid", width_mm: "width-mm"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      SUBPIXEL_LAYOUT_DOMAIN = [:unknown, :none, :horizontal_rgb, :horizontal_bgr, :vertical_rgb, :vertical_bgr].freeze

      attr_reader :connector, :description, :display, :geometry, :height_mm, :manufacturer, :model, :refresh_rate, :scale, :scale_factor, :subpixel_layout, :valid, :width_mm
    end
  end

  module Gdk
    class MotionEvent < Event

      TYPE = "Gdk.MotionEvent"
      GTYPE = "GdkMotionEvent"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class PadEvent < Event

      TYPE = "Gdk.PadEvent"
      GTYPE = "GdkPadEvent"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class ProximityEvent < Event

      TYPE = "Gdk.ProximityEvent"
      GTYPE = "GdkProximityEvent"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class ScrollEvent < Event

      TYPE = "Gdk.ScrollEvent"
      GTYPE = "GdkScrollEvent"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class Seat < GtkAst::GObject::Object

      TYPE = "Gdk.Seat"
      GTYPE = "GdkSeat"
      FIELDS = [:display].freeze
      PROPERTIES = {display: "display"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :display
    end
  end

  module Gdk
    class Snapshot < GtkAst::GObject::Object

      TYPE = "Gdk.Snapshot"
      GTYPE = "GdkSnapshot"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class TouchEvent < Event

      TYPE = "Gdk.TouchEvent"
      GTYPE = "GdkTouchEvent"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class TouchpadEvent < Event

      TYPE = "Gdk.TouchpadEvent"
      GTYPE = "GdkTouchpadEvent"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gdk
    class VulkanContext < DrawContext

      TYPE = "Gdk.VulkanContext"
      GTYPE = "GdkVulkanContext"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GdkPixbuf
    class Pixbuf < GtkAst::GObject::Object
      include GtkAst::Gio::Icon
      include GtkAst::Gio::LoadableIcon

      TYPE = "GdkPixbuf.Pixbuf"
      GTYPE = "GdkPixbuf"
      FIELDS = [:bits_per_sample, :colorspace, :has_alpha, :height, :n_channels, :pixel_bytes, :pixels, :rowstride, :width].freeze
      PROPERTIES = {bits_per_sample: "bits-per-sample", colorspace: "colorspace", has_alpha: "has-alpha", height: "height", n_channels: "n-channels", pixel_bytes: "pixel-bytes", pixels: "pixels", rowstride: "rowstride", width: "width"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::Icon::FIELDS + GtkAst::Gio::LoadableIcon::FIELDS + FIELDS).uniq.freeze
      COLORSPACE_DOMAIN = [:rgb].freeze

      attr_reader :bits_per_sample, :colorspace, :has_alpha, :height, :n_channels, :pixel_bytes, :pixels, :rowstride, :width
    end
  end

  module GdkPixbuf
    class PixbufAnimation < GtkAst::GObject::Object

      TYPE = "GdkPixbuf.PixbufAnimation"
      GTYPE = "GdkPixbufAnimation"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GdkPixbuf
    class PixbufAnimationIter < GtkAst::GObject::Object

      TYPE = "GdkPixbuf.PixbufAnimationIter"
      GTYPE = "GdkPixbufAnimationIter"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GdkPixbuf
    class PixbufLoader < GtkAst::GObject::Object

      TYPE = "GdkPixbuf.PixbufLoader"
      GTYPE = "GdkPixbufLoader"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GdkPixbuf
    class PixbufNonAnim < PixbufAnimation

      TYPE = "GdkPixbuf.PixbufNonAnim"
      GTYPE = "GdkPixbufNonAnim"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module GdkPixbuf
    class PixbufSimpleAnim < PixbufAnimation

      TYPE = "GdkPixbuf.PixbufSimpleAnim"
      GTYPE = "GdkPixbufSimpleAnim"
      FIELDS = [:loop].freeze
      PROPERTIES = {loop: "loop"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :loop
    end
  end

  module GdkPixbuf
    class PixbufSimpleAnimIter < PixbufAnimationIter

      TYPE = "GdkPixbuf.PixbufSimpleAnimIter"
      GTYPE = "GdkPixbufSimpleAnimIter"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class AppInfoMonitor < GtkAst::GObject::Object

      TYPE = "Gio.AppInfoMonitor"
      GTYPE = "GAppInfoMonitor"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class ApplicationCommandLine < GtkAst::GObject::Object

      TYPE = "Gio.ApplicationCommandLine"
      GTYPE = "GApplicationCommandLine"
      FIELDS = [:arguments, :is_remote, :options, :platform_data].freeze
      PROPERTIES = {arguments: "arguments", is_remote: "is-remote", options: "options", platform_data: "platform-data"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :arguments, :is_remote, :options, :platform_data
    end
  end

  module Gio
    class FilterInputStream < InputStream

      TYPE = "Gio.FilterInputStream"
      GTYPE = "GFilterInputStream"
      FIELDS = [:base_stream, :close_base_stream].freeze
      PROPERTIES = {base_stream: "base-stream", close_base_stream: "close-base-stream"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :base_stream, :close_base_stream
    end
  end

  module Gio
    class BufferedInputStream < FilterInputStream
      include Seekable

      TYPE = "Gio.BufferedInputStream"
      GTYPE = "GBufferedInputStream"
      FIELDS = [:buffer_size].freeze
      PROPERTIES = {buffer_size: "buffer-size"}.freeze
      KEYS = (superclass::KEYS + Seekable::FIELDS + FIELDS).uniq.freeze

      attr_reader :buffer_size
    end
  end

  module Gio
    class FilterOutputStream < OutputStream

      TYPE = "Gio.FilterOutputStream"
      GTYPE = "GFilterOutputStream"
      FIELDS = [:base_stream, :close_base_stream].freeze
      PROPERTIES = {base_stream: "base-stream", close_base_stream: "close-base-stream"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :base_stream, :close_base_stream
    end
  end

  module Gio
    class BufferedOutputStream < FilterOutputStream
      include Seekable

      TYPE = "Gio.BufferedOutputStream"
      GTYPE = "GBufferedOutputStream"
      FIELDS = [:auto_grow, :buffer_size].freeze
      PROPERTIES = {auto_grow: "auto-grow", buffer_size: "buffer-size"}.freeze
      KEYS = (superclass::KEYS + Seekable::FIELDS + FIELDS).uniq.freeze

      attr_reader :auto_grow, :buffer_size
    end
  end

  module Gio
    class BytesIcon < GtkAst::GObject::Object
      include Icon
      include LoadableIcon

      TYPE = "Gio.BytesIcon"
      GTYPE = "GBytesIcon"
      FIELDS = [:bytes].freeze
      PROPERTIES = {bytes: "bytes"}.freeze
      KEYS = (superclass::KEYS + Icon::FIELDS + LoadableIcon::FIELDS + FIELDS).uniq.freeze

      attr_reader :bytes
    end
  end

  module Gio
    class Cancellable < GtkAst::GObject::Object

      TYPE = "Gio.Cancellable"
      GTYPE = "GCancellable"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class CharsetConverter < GtkAst::GObject::Object
      include Converter
      include Initable

      TYPE = "Gio.CharsetConverter"
      GTYPE = "GCharsetConverter"
      FIELDS = [:from_charset, :to_charset, :use_fallback].freeze
      PROPERTIES = {from_charset: "from-charset", to_charset: "to-charset", use_fallback: "use-fallback"}.freeze
      KEYS = (superclass::KEYS + Converter::FIELDS + Initable::FIELDS + FIELDS).uniq.freeze

      attr_reader :from_charset, :to_charset, :use_fallback
    end
  end

  module Gio
    class ConverterInputStream < FilterInputStream
      include PollableInputStream

      TYPE = "Gio.ConverterInputStream"
      GTYPE = "GConverterInputStream"
      FIELDS = [:converter].freeze
      PROPERTIES = {converter: "converter"}.freeze
      KEYS = (superclass::KEYS + PollableInputStream::FIELDS + FIELDS).uniq.freeze

      attr_reader :converter
    end
  end

  module Gio
    class ConverterOutputStream < FilterOutputStream
      include PollableOutputStream

      TYPE = "Gio.ConverterOutputStream"
      GTYPE = "GConverterOutputStream"
      FIELDS = [:converter].freeze
      PROPERTIES = {converter: "converter"}.freeze
      KEYS = (superclass::KEYS + PollableOutputStream::FIELDS + FIELDS).uniq.freeze

      attr_reader :converter
    end
  end

  module Gio
    class Credentials < GtkAst::GObject::Object

      TYPE = "Gio.Credentials"
      GTYPE = "GCredentials"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class DBusActionGroup < GtkAst::GObject::Object
      include ActionGroup
      include RemoteActionGroup

      TYPE = "Gio.DBusActionGroup"
      GTYPE = "GDBusActionGroup"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + ActionGroup::FIELDS + RemoteActionGroup::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class DBusAuthObserver < GtkAst::GObject::Object

      TYPE = "Gio.DBusAuthObserver"
      GTYPE = "GDBusAuthObserver"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class DBusConnection < GtkAst::GObject::Object
      include AsyncInitable
      include Initable

      TYPE = "Gio.DBusConnection"
      GTYPE = "GDBusConnection"
      FIELDS = [:address, :authentication_observer, :capabilities, :closed, :exit_on_close, :flags, :guid, :stream, :unique_name].freeze
      PROPERTIES = {address: "address", authentication_observer: "authentication-observer", capabilities: "capabilities", closed: "closed", exit_on_close: "exit-on-close", flags: "flags", guid: "guid", stream: "stream", unique_name: "unique-name"}.freeze
      KEYS = (superclass::KEYS + AsyncInitable::FIELDS + Initable::FIELDS + FIELDS).uniq.freeze
      CAPABILITIES_DOMAIN = [:none, :unix_fd_passing].freeze
      FLAGS_DOMAIN = [:none, :authentication_client, :authentication_server, :authentication_allow_anonymous, :message_bus_connection, :delay_message_processing, :authentication_require_same_user, :cross_namespace].freeze

      attr_reader :address, :authentication_observer, :capabilities, :closed, :exit_on_close, :flags, :guid, :stream, :unique_name
    end
  end

  module Gio
    class DBusInterfaceSkeleton < GtkAst::GObject::Object
      include DBusInterface

      TYPE = "Gio.DBusInterfaceSkeleton"
      GTYPE = "GDBusInterfaceSkeleton"
      FIELDS = [:g_flags].freeze
      PROPERTIES = {g_flags: "g-flags"}.freeze
      KEYS = (superclass::KEYS + DBusInterface::FIELDS + FIELDS).uniq.freeze
      G_FLAGS_DOMAIN = [:none, :handle_method_invocations_in_thread].freeze

      attr_reader :g_flags
    end
  end

  module Gio
    class MenuModel < GtkAst::GObject::Object

      TYPE = "Gio.MenuModel"
      GTYPE = "GMenuModel"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class DBusMenuModel < MenuModel

      TYPE = "Gio.DBusMenuModel"
      GTYPE = "GDBusMenuModel"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class DBusMessage < GtkAst::GObject::Object

      TYPE = "Gio.DBusMessage"
      GTYPE = "GDBusMessage"
      FIELDS = [:locked].freeze
      PROPERTIES = {locked: "locked"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :locked
    end
  end

  module Gio
    class DBusMethodInvocation < GtkAst::GObject::Object

      TYPE = "Gio.DBusMethodInvocation"
      GTYPE = "GDBusMethodInvocation"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class DBusObjectManagerClient < GtkAst::GObject::Object
      include AsyncInitable
      include DBusObjectManager
      include Initable

      TYPE = "Gio.DBusObjectManagerClient"
      GTYPE = "GDBusObjectManagerClient"
      FIELDS = [:bus_type, :connection, :flags, :get_proxy_type_destroy_notify, :get_proxy_type_func, :get_proxy_type_user_data, :name, :name_owner, :object_path].freeze
      PROPERTIES = {bus_type: "bus-type", connection: "connection", flags: "flags", get_proxy_type_destroy_notify: "get-proxy-type-destroy-notify", get_proxy_type_func: "get-proxy-type-func", get_proxy_type_user_data: "get-proxy-type-user-data", name: "name", name_owner: "name-owner", object_path: "object-path"}.freeze
      KEYS = (superclass::KEYS + AsyncInitable::FIELDS + DBusObjectManager::FIELDS + Initable::FIELDS + FIELDS).uniq.freeze
      BUS_TYPE_DOMAIN = [:starter, :none, :system, :session].freeze
      FLAGS_DOMAIN = [:none, :do_not_auto_start].freeze

      attr_reader :bus_type, :connection, :flags, :get_proxy_type_destroy_notify, :get_proxy_type_func, :get_proxy_type_user_data, :name, :name_owner, :object_path
    end
  end

  module Gio
    class DBusObjectManagerServer < GtkAst::GObject::Object
      include DBusObjectManager

      TYPE = "Gio.DBusObjectManagerServer"
      GTYPE = "GDBusObjectManagerServer"
      FIELDS = [:connection, :object_path].freeze
      PROPERTIES = {connection: "connection", object_path: "object-path"}.freeze
      KEYS = (superclass::KEYS + DBusObjectManager::FIELDS + FIELDS).uniq.freeze

      attr_reader :connection, :object_path
    end
  end

  module Gio
    class DBusObjectProxy < GtkAst::GObject::Object
      include DBusObject

      TYPE = "Gio.DBusObjectProxy"
      GTYPE = "GDBusObjectProxy"
      FIELDS = [:g_connection, :g_object_path].freeze
      PROPERTIES = {g_connection: "g-connection", g_object_path: "g-object-path"}.freeze
      KEYS = (superclass::KEYS + DBusObject::FIELDS + FIELDS).uniq.freeze

      attr_reader :g_connection, :g_object_path
    end
  end

  module Gio
    class DBusObjectSkeleton < GtkAst::GObject::Object
      include DBusObject

      TYPE = "Gio.DBusObjectSkeleton"
      GTYPE = "GDBusObjectSkeleton"
      FIELDS = [:g_object_path].freeze
      PROPERTIES = {g_object_path: "g-object-path"}.freeze
      KEYS = (superclass::KEYS + DBusObject::FIELDS + FIELDS).uniq.freeze

      attr_reader :g_object_path
    end
  end

  module Gio
    class DBusProxy < GtkAst::GObject::Object
      include AsyncInitable
      include DBusInterface
      include Initable

      TYPE = "Gio.DBusProxy"
      GTYPE = "GDBusProxy"
      FIELDS = [:g_bus_type, :g_connection, :g_default_timeout, :g_flags, :g_interface_info, :g_interface_name, :g_name, :g_name_owner, :g_object_path].freeze
      PROPERTIES = {g_bus_type: "g-bus-type", g_connection: "g-connection", g_default_timeout: "g-default-timeout", g_flags: "g-flags", g_interface_info: "g-interface-info", g_interface_name: "g-interface-name", g_name: "g-name", g_name_owner: "g-name-owner", g_object_path: "g-object-path"}.freeze
      KEYS = (superclass::KEYS + AsyncInitable::FIELDS + DBusInterface::FIELDS + Initable::FIELDS + FIELDS).uniq.freeze
      G_BUS_TYPE_DOMAIN = [:starter, :none, :system, :session].freeze
      G_FLAGS_DOMAIN = [:none, :do_not_load_properties, :do_not_connect_signals, :do_not_auto_start, :get_invalidated_properties, :do_not_auto_start_at_construction, :no_match_rule].freeze

      attr_reader :g_bus_type, :g_connection, :g_default_timeout, :g_flags, :g_interface_info, :g_interface_name, :g_name, :g_name_owner, :g_object_path
    end
  end

  module Gio
    class DBusServer < GtkAst::GObject::Object
      include Initable

      TYPE = "Gio.DBusServer"
      GTYPE = "GDBusServer"
      FIELDS = [:active, :address, :authentication_observer, :client_address, :flags, :guid].freeze
      PROPERTIES = {active: "active", address: "address", authentication_observer: "authentication-observer", client_address: "client-address", flags: "flags", guid: "guid"}.freeze
      KEYS = (superclass::KEYS + Initable::FIELDS + FIELDS).uniq.freeze
      FLAGS_DOMAIN = [:none, :run_in_thread, :authentication_allow_anonymous, :authentication_require_same_user].freeze

      attr_reader :active, :address, :authentication_observer, :client_address, :flags, :guid
    end
  end

  module Gio
    class DataInputStream < BufferedInputStream
      include Seekable

      TYPE = "Gio.DataInputStream"
      GTYPE = "GDataInputStream"
      FIELDS = [:byte_order, :newline_type].freeze
      PROPERTIES = {byte_order: "byte-order", newline_type: "newline-type"}.freeze
      KEYS = (superclass::KEYS + Seekable::FIELDS + FIELDS).uniq.freeze
      BYTE_ORDER_DOMAIN = [:big_endian, :little_endian, :host_endian].freeze
      NEWLINE_TYPE_DOMAIN = [:lf, :cr, :cr_lf, :any].freeze

      attr_reader :byte_order, :newline_type
    end
  end

  module Gio
    class DataOutputStream < FilterOutputStream
      include Seekable

      TYPE = "Gio.DataOutputStream"
      GTYPE = "GDataOutputStream"
      FIELDS = [:byte_order].freeze
      PROPERTIES = {byte_order: "byte-order"}.freeze
      KEYS = (superclass::KEYS + Seekable::FIELDS + FIELDS).uniq.freeze
      BYTE_ORDER_DOMAIN = [:big_endian, :little_endian, :host_endian].freeze

      attr_reader :byte_order
    end
  end

  module Gio
    class DebugControllerDBus < GtkAst::GObject::Object
      include DebugController
      include Initable

      TYPE = "Gio.DebugControllerDBus"
      GTYPE = "GDebugControllerDBus"
      FIELDS = [:connection].freeze
      PROPERTIES = {connection: "connection"}.freeze
      KEYS = (superclass::KEYS + DebugController::FIELDS + Initable::FIELDS + FIELDS).uniq.freeze

      attr_reader :connection
    end
  end

  module Gio
    class Emblem < GtkAst::GObject::Object
      include Icon

      TYPE = "Gio.Emblem"
      GTYPE = "GEmblem"
      FIELDS = [:icon, :origin].freeze
      PROPERTIES = {icon: "icon", origin: "origin"}.freeze
      KEYS = (superclass::KEYS + Icon::FIELDS + FIELDS).uniq.freeze
      ORIGIN_DOMAIN = [:unknown, :device, :livemetadata, :tag].freeze

      attr_reader :icon, :origin
    end
  end

  module Gio
    class EmblemedIcon < GtkAst::GObject::Object
      include Icon

      TYPE = "Gio.EmblemedIcon"
      GTYPE = "GEmblemedIcon"
      FIELDS = [:gicon].freeze
      PROPERTIES = {gicon: "gicon"}.freeze
      KEYS = (superclass::KEYS + Icon::FIELDS + FIELDS).uniq.freeze

      attr_reader :gicon
    end
  end

  module Gio
    class FileEnumerator < GtkAst::GObject::Object

      TYPE = "Gio.FileEnumerator"
      GTYPE = "GFileEnumerator"
      FIELDS = [:container].freeze
      PROPERTIES = {container: "container"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :container
    end
  end

  module Gio
    class FileIOStream < IOStream
      include Seekable

      TYPE = "Gio.FileIOStream"
      GTYPE = "GFileIOStream"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Seekable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class FileIcon < GtkAst::GObject::Object
      include Icon
      include LoadableIcon

      TYPE = "Gio.FileIcon"
      GTYPE = "GFileIcon"
      FIELDS = [:file].freeze
      PROPERTIES = {file: "file"}.freeze
      KEYS = (superclass::KEYS + Icon::FIELDS + LoadableIcon::FIELDS + FIELDS).uniq.freeze

      attr_reader :file
    end
  end

  module Gio
    class FileInfo < GtkAst::GObject::Object

      TYPE = "Gio.FileInfo"
      GTYPE = "GFileInfo"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class FileInputStream < InputStream
      include Seekable

      TYPE = "Gio.FileInputStream"
      GTYPE = "GFileInputStream"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Seekable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class FileMonitor < GtkAst::GObject::Object

      TYPE = "Gio.FileMonitor"
      GTYPE = "GFileMonitor"
      FIELDS = [:cancelled, :rate_limit].freeze
      PROPERTIES = {cancelled: "cancelled", rate_limit: "rate-limit"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :cancelled, :rate_limit
    end
  end

  module Gio
    class FileOutputStream < OutputStream
      include Seekable

      TYPE = "Gio.FileOutputStream"
      GTYPE = "GFileOutputStream"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Seekable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class FilenameCompleter < GtkAst::GObject::Object

      TYPE = "Gio.FilenameCompleter"
      GTYPE = "GFilenameCompleter"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class IOModule < GtkAst::GObject::TypeModule
      include GtkAst::GObject::TypePlugin

      TYPE = "Gio.IOModule"
      GTYPE = "GIOModule"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + GtkAst::GObject::TypePlugin::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class SocketControlMessage < GtkAst::GObject::Object

      TYPE = "Gio.SocketControlMessage"
      GTYPE = "GSocketControlMessage"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class IPTosMessage < SocketControlMessage

      TYPE = "Gio.IPTosMessage"
      GTYPE = "GIPTosMessage"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class IPv6TclassMessage < SocketControlMessage

      TYPE = "Gio.IPv6TclassMessage"
      GTYPE = "GIPv6TclassMessage"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class InetAddress < GtkAst::GObject::Object

      TYPE = "Gio.InetAddress"
      GTYPE = "GInetAddress"
      FIELDS = [:bytes, :family, :flowinfo, :is_any, :is_link_local, :is_loopback, :is_mc_global, :is_mc_link_local, :is_mc_node_local, :is_mc_org_local, :is_mc_site_local, :is_multicast, :is_site_local, :scope_id].freeze
      PROPERTIES = {bytes: "bytes", family: "family", flowinfo: "flowinfo", is_any: "is-any", is_link_local: "is-link-local", is_loopback: "is-loopback", is_mc_global: "is-mc-global", is_mc_link_local: "is-mc-link-local", is_mc_node_local: "is-mc-node-local", is_mc_org_local: "is-mc-org-local", is_mc_site_local: "is-mc-site-local", is_multicast: "is-multicast", is_site_local: "is-site-local", scope_id: "scope-id"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      FAMILY_DOMAIN = [:invalid, :unix, :ipv4, :ipv6].freeze

      attr_reader :bytes, :family, :flowinfo, :is_any, :is_link_local, :is_loopback, :is_mc_global, :is_mc_link_local, :is_mc_node_local, :is_mc_org_local, :is_mc_site_local, :is_multicast, :is_site_local, :scope_id
    end
  end

  module Gio
    class InetAddressMask < GtkAst::GObject::Object
      include Initable

      TYPE = "Gio.InetAddressMask"
      GTYPE = "GInetAddressMask"
      FIELDS = [:address, :family, :length].freeze
      PROPERTIES = {address: "address", family: "family", length: "length"}.freeze
      KEYS = (superclass::KEYS + Initable::FIELDS + FIELDS).uniq.freeze
      FAMILY_DOMAIN = [:invalid, :unix, :ipv4, :ipv6].freeze

      attr_reader :address, :family, :length
    end
  end

  module Gio
    class SocketAddress < GtkAst::GObject::Object
      include SocketConnectable

      TYPE = "Gio.SocketAddress"
      GTYPE = "GSocketAddress"
      FIELDS = [:family].freeze
      PROPERTIES = {family: "family"}.freeze
      KEYS = (superclass::KEYS + SocketConnectable::FIELDS + FIELDS).uniq.freeze
      FAMILY_DOMAIN = [:invalid, :unix, :ipv4, :ipv6].freeze

      attr_reader :family
    end
  end

  module Gio
    class InetSocketAddress < SocketAddress
      include SocketConnectable

      TYPE = "Gio.InetSocketAddress"
      GTYPE = "GInetSocketAddress"
      FIELDS = [:address, :flowinfo, :port, :scope_id].freeze
      PROPERTIES = {address: "address", flowinfo: "flowinfo", port: "port", scope_id: "scope-id"}.freeze
      KEYS = (superclass::KEYS + SocketConnectable::FIELDS + FIELDS).uniq.freeze

      attr_reader :address, :flowinfo, :port, :scope_id
    end
  end

  module Gio
    class ListStore < GtkAst::GObject::Object
      include ListModel

      TYPE = "Gio.ListStore"
      GTYPE = "GListStore"
      FIELDS = [:item_type, :n_items].freeze
      PROPERTIES = {item_type: "item-type", n_items: "n-items"}.freeze
      KEYS = (superclass::KEYS + ListModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :item_type, :n_items
    end
  end

  module Gio
    class MemoryInputStream < InputStream
      include PollableInputStream
      include Seekable

      TYPE = "Gio.MemoryInputStream"
      GTYPE = "GMemoryInputStream"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + PollableInputStream::FIELDS + Seekable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class MemoryOutputStream < OutputStream
      include PollableOutputStream
      include Seekable

      TYPE = "Gio.MemoryOutputStream"
      GTYPE = "GMemoryOutputStream"
      FIELDS = [:data, :data_size, :destroy_function, :realloc_function, :size].freeze
      PROPERTIES = {data: "data", data_size: "data-size", destroy_function: "destroy-function", realloc_function: "realloc-function", size: "size"}.freeze
      KEYS = (superclass::KEYS + PollableOutputStream::FIELDS + Seekable::FIELDS + FIELDS).uniq.freeze

      attr_reader :data, :data_size, :destroy_function, :realloc_function, :size
    end
  end

  module Gio
    class Menu < MenuModel

      TYPE = "Gio.Menu"
      GTYPE = "GMenu"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class MenuAttributeIter < GtkAst::GObject::Object

      TYPE = "Gio.MenuAttributeIter"
      GTYPE = "GMenuAttributeIter"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class MenuItem < GtkAst::GObject::Object

      TYPE = "Gio.MenuItem"
      GTYPE = "GMenuItem"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class MenuLinkIter < GtkAst::GObject::Object

      TYPE = "Gio.MenuLinkIter"
      GTYPE = "GMenuLinkIter"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class MountOperation < GtkAst::GObject::Object

      TYPE = "Gio.MountOperation"
      GTYPE = "GMountOperation"
      FIELDS = [:anonymous, :choice, :domain, :is_tcrypt_hidden_volume, :is_tcrypt_system_volume, :password, :password_save, :pim, :username].freeze
      PROPERTIES = {anonymous: "anonymous", choice: "choice", domain: "domain", is_tcrypt_hidden_volume: "is-tcrypt-hidden-volume", is_tcrypt_system_volume: "is-tcrypt-system-volume", password: "password", password_save: "password-save", pim: "pim", username: "username"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      PASSWORD_SAVE_DOMAIN = [:never, :for_session, :permanently].freeze

      attr_reader :anonymous, :choice, :domain, :is_tcrypt_hidden_volume, :is_tcrypt_system_volume, :password, :password_save, :pim, :username
    end
  end

  module Gio
    class NativeSocketAddress < SocketAddress
      include SocketConnectable

      TYPE = "Gio.NativeSocketAddress"
      GTYPE = "GNativeSocketAddress"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + SocketConnectable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class VolumeMonitor < GtkAst::GObject::Object

      TYPE = "Gio.VolumeMonitor"
      GTYPE = "GVolumeMonitor"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class NativeVolumeMonitor < VolumeMonitor

      TYPE = "Gio.NativeVolumeMonitor"
      GTYPE = "GNativeVolumeMonitor"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class NetworkAddress < GtkAst::GObject::Object
      include SocketConnectable

      TYPE = "Gio.NetworkAddress"
      GTYPE = "GNetworkAddress"
      FIELDS = [:hostname, :port, :scheme].freeze
      PROPERTIES = {hostname: "hostname", port: "port", scheme: "scheme"}.freeze
      KEYS = (superclass::KEYS + SocketConnectable::FIELDS + FIELDS).uniq.freeze

      attr_reader :hostname, :port, :scheme
    end
  end

  module Gio
    class NetworkService < GtkAst::GObject::Object
      include SocketConnectable

      TYPE = "Gio.NetworkService"
      GTYPE = "GNetworkService"
      FIELDS = [:domain, :protocol, :scheme, :service].freeze
      PROPERTIES = {domain: "domain", protocol: "protocol", scheme: "scheme", service: "service"}.freeze
      KEYS = (superclass::KEYS + SocketConnectable::FIELDS + FIELDS).uniq.freeze

      attr_reader :domain, :protocol, :scheme, :service
    end
  end

  module Gio
    class Notification < GtkAst::GObject::Object

      TYPE = "Gio.Notification"
      GTYPE = "GNotification"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class Permission < GtkAst::GObject::Object

      TYPE = "Gio.Permission"
      GTYPE = "GPermission"
      FIELDS = [:allowed, :can_acquire, :can_release].freeze
      PROPERTIES = {allowed: "allowed", can_acquire: "can-acquire", can_release: "can-release"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :allowed, :can_acquire, :can_release
    end
  end

  module Gio
    class PropertyAction < GtkAst::GObject::Object
      include Action

      TYPE = "Gio.PropertyAction"
      GTYPE = "GPropertyAction"
      FIELDS = [:enabled, :invert_boolean, :name, :object, :parameter_type, :property_name, :state, :state_type].freeze
      PROPERTIES = {enabled: "enabled", invert_boolean: "invert-boolean", name: "name", object: "object", parameter_type: "parameter-type", property_name: "property-name", state: "state", state_type: "state-type"}.freeze
      KEYS = (superclass::KEYS + Action::FIELDS + FIELDS).uniq.freeze

      attr_reader :enabled, :invert_boolean, :name, :object, :parameter_type, :property_name, :state, :state_type
    end
  end

  module Gio
    class ProxyAddress < InetSocketAddress
      include SocketConnectable

      TYPE = "Gio.ProxyAddress"
      GTYPE = "GProxyAddress"
      FIELDS = [:destination_hostname, :destination_port, :destination_protocol, :password, :protocol, :uri, :username].freeze
      PROPERTIES = {destination_hostname: "destination-hostname", destination_port: "destination-port", destination_protocol: "destination-protocol", password: "password", protocol: "protocol", uri: "uri", username: "username"}.freeze
      KEYS = (superclass::KEYS + SocketConnectable::FIELDS + FIELDS).uniq.freeze

      attr_reader :destination_hostname, :destination_port, :destination_protocol, :password, :protocol, :uri, :username
    end
  end

  module Gio
    class SocketAddressEnumerator < GtkAst::GObject::Object

      TYPE = "Gio.SocketAddressEnumerator"
      GTYPE = "GSocketAddressEnumerator"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class ProxyAddressEnumerator < SocketAddressEnumerator

      TYPE = "Gio.ProxyAddressEnumerator"
      GTYPE = "GProxyAddressEnumerator"
      FIELDS = [:connectable, :default_port, :proxy_resolver, :uri].freeze
      PROPERTIES = {connectable: "connectable", default_port: "default-port", proxy_resolver: "proxy-resolver", uri: "uri"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :connectable, :default_port, :proxy_resolver, :uri
    end
  end

  module Gio
    class Resolver < GtkAst::GObject::Object

      TYPE = "Gio.Resolver"
      GTYPE = "GResolver"
      FIELDS = [:timeout].freeze
      PROPERTIES = {timeout: "timeout"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :timeout
    end
  end

  module Gio
    class Settings < GtkAst::GObject::Object

      TYPE = "Gio.Settings"
      GTYPE = "GSettings"
      FIELDS = [:backend, :delay_apply, :has_unapplied, :path, :schema, :schema_id, :settings_schema].freeze
      PROPERTIES = {backend: "backend", delay_apply: "delay-apply", has_unapplied: "has-unapplied", path: "path", schema: "schema", schema_id: "schema-id", settings_schema: "settings-schema"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :backend, :delay_apply, :has_unapplied, :path, :schema, :schema_id, :settings_schema
    end
  end

  module Gio
    class SettingsBackend < GtkAst::GObject::Object

      TYPE = "Gio.SettingsBackend"
      GTYPE = "GSettingsBackend"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class SimpleAction < GtkAst::GObject::Object
      include Action

      TYPE = "Gio.SimpleAction"
      GTYPE = "GSimpleAction"
      FIELDS = [:enabled, :name, :parameter_type, :state, :state_type].freeze
      PROPERTIES = {enabled: "enabled", name: "name", parameter_type: "parameter-type", state: "state", state_type: "state-type"}.freeze
      KEYS = (superclass::KEYS + Action::FIELDS + FIELDS).uniq.freeze

      attr_reader :enabled, :name, :parameter_type, :state, :state_type
    end
  end

  module Gio
    class SimpleActionGroup < GtkAst::GObject::Object
      include ActionGroup
      include ActionMap

      TYPE = "Gio.SimpleActionGroup"
      GTYPE = "GSimpleActionGroup"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + ActionGroup::FIELDS + ActionMap::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class SimpleAsyncResult < GtkAst::GObject::Object
      include AsyncResult

      TYPE = "Gio.SimpleAsyncResult"
      GTYPE = "GSimpleAsyncResult"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + AsyncResult::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class SimpleIOStream < IOStream

      TYPE = "Gio.SimpleIOStream"
      GTYPE = "GSimpleIOStream"
      FIELDS = [:input_stream, :output_stream].freeze
      PROPERTIES = {input_stream: "input-stream", output_stream: "output-stream"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :input_stream, :output_stream
    end
  end

  module Gio
    class SimplePermission < Permission

      TYPE = "Gio.SimplePermission"
      GTYPE = "GSimplePermission"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class SimpleProxyResolver < GtkAst::GObject::Object
      include ProxyResolver

      TYPE = "Gio.SimpleProxyResolver"
      GTYPE = "GSimpleProxyResolver"
      FIELDS = [:default_proxy, :ignore_hosts].freeze
      PROPERTIES = {default_proxy: "default-proxy", ignore_hosts: "ignore-hosts"}.freeze
      KEYS = (superclass::KEYS + ProxyResolver::FIELDS + FIELDS).uniq.freeze

      attr_reader :default_proxy, :ignore_hosts
    end
  end

  module Gio
    class Socket < GtkAst::GObject::Object
      include DatagramBased
      include Initable

      TYPE = "Gio.Socket"
      GTYPE = "GSocket"
      FIELDS = [:blocking, :broadcast, :family, :fd, :keepalive, :listen_backlog, :local_address, :multicast_loopback, :multicast_ttl, :protocol, :remote_address, :timeout, :ttl, :type].freeze
      PROPERTIES = {blocking: "blocking", broadcast: "broadcast", family: "family", fd: "fd", keepalive: "keepalive", listen_backlog: "listen-backlog", local_address: "local-address", multicast_loopback: "multicast-loopback", multicast_ttl: "multicast-ttl", protocol: "protocol", remote_address: "remote-address", timeout: "timeout", ttl: "ttl", type: "type"}.freeze
      KEYS = (superclass::KEYS + DatagramBased::FIELDS + Initable::FIELDS + FIELDS).uniq.freeze
      FAMILY_DOMAIN = [:invalid, :unix, :ipv4, :ipv6].freeze
      PROTOCOL_DOMAIN = [:unknown, :default, :tcp, :udp, :sctp].freeze
      TYPE_DOMAIN = [:invalid, :stream, :datagram, :seqpacket].freeze

      attr_reader :blocking, :broadcast, :family, :fd, :keepalive, :listen_backlog, :local_address, :multicast_loopback, :multicast_ttl, :protocol, :remote_address, :timeout, :ttl, :type
    end
  end

  module Gio
    class SocketClient < GtkAst::GObject::Object

      TYPE = "Gio.SocketClient"
      GTYPE = "GSocketClient"
      FIELDS = [:enable_proxy, :family, :local_address, :protocol, :proxy_resolver, :timeout, :tls, :tls_validation_flags, :type].freeze
      PROPERTIES = {enable_proxy: "enable-proxy", family: "family", local_address: "local-address", protocol: "protocol", proxy_resolver: "proxy-resolver", timeout: "timeout", tls: "tls", tls_validation_flags: "tls-validation-flags", type: "type"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      FAMILY_DOMAIN = [:invalid, :unix, :ipv4, :ipv6].freeze
      PROTOCOL_DOMAIN = [:unknown, :default, :tcp, :udp, :sctp].freeze
      TLS_VALIDATION_FLAGS_DOMAIN = [:no_flags, :unknown_ca, :bad_identity, :not_activated, :expired, :revoked, :insecure, :generic_error, :validate_all].freeze
      TYPE_DOMAIN = [:invalid, :stream, :datagram, :seqpacket].freeze

      attr_reader :enable_proxy, :family, :local_address, :protocol, :proxy_resolver, :timeout, :tls, :tls_validation_flags, :type
    end
  end

  module Gio
    class SocketConnection < IOStream

      TYPE = "Gio.SocketConnection"
      GTYPE = "GSocketConnection"
      FIELDS = [:socket].freeze
      PROPERTIES = {socket: "socket"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :socket
    end
  end

  module Gio
    class SocketListener < GtkAst::GObject::Object

      TYPE = "Gio.SocketListener"
      GTYPE = "GSocketListener"
      FIELDS = [:listen_backlog].freeze
      PROPERTIES = {listen_backlog: "listen-backlog"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :listen_backlog
    end
  end

  module Gio
    class SocketService < SocketListener

      TYPE = "Gio.SocketService"
      GTYPE = "GSocketService"
      FIELDS = [:active].freeze
      PROPERTIES = {active: "active"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :active
    end
  end

  module Gio
    class Subprocess < GtkAst::GObject::Object
      include Initable

      TYPE = "Gio.Subprocess"
      GTYPE = "GSubprocess"
      FIELDS = [:argv, :flags].freeze
      PROPERTIES = {argv: "argv", flags: "flags"}.freeze
      KEYS = (superclass::KEYS + Initable::FIELDS + FIELDS).uniq.freeze
      FLAGS_DOMAIN = [:none, :stdin_pipe, :stdin_inherit, :stdout_pipe, :stdout_silence, :stderr_pipe, :stderr_silence, :stderr_merge, :inherit_fds, :search_path_from_envp].freeze

      attr_reader :argv, :flags
    end
  end

  module Gio
    class SubprocessLauncher < GtkAst::GObject::Object

      TYPE = "Gio.SubprocessLauncher"
      GTYPE = "GSubprocessLauncher"
      FIELDS = [:flags].freeze
      PROPERTIES = {flags: "flags"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      FLAGS_DOMAIN = [:none, :stdin_pipe, :stdin_inherit, :stdout_pipe, :stdout_silence, :stderr_pipe, :stderr_silence, :stderr_merge, :inherit_fds, :search_path_from_envp].freeze

      attr_reader :flags
    end
  end

  module Gio
    class Task < GtkAst::GObject::Object
      include AsyncResult

      TYPE = "Gio.Task"
      GTYPE = "GTask"
      FIELDS = [:completed].freeze
      PROPERTIES = {completed: "completed"}.freeze
      KEYS = (superclass::KEYS + AsyncResult::FIELDS + FIELDS).uniq.freeze

      attr_reader :completed
    end
  end

  module Gio
    class TcpConnection < SocketConnection

      TYPE = "Gio.TcpConnection"
      GTYPE = "GTcpConnection"
      FIELDS = [:graceful_disconnect].freeze
      PROPERTIES = {graceful_disconnect: "graceful-disconnect"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :graceful_disconnect
    end
  end

  module Gio
    class TcpWrapperConnection < TcpConnection

      TYPE = "Gio.TcpWrapperConnection"
      GTYPE = "GTcpWrapperConnection"
      FIELDS = [:base_io_stream].freeze
      PROPERTIES = {base_io_stream: "base-io-stream"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :base_io_stream
    end
  end

  module Gio
    class TestDBus < GtkAst::GObject::Object

      TYPE = "Gio.TestDBus"
      GTYPE = "GTestDBus"
      FIELDS = [:flags].freeze
      PROPERTIES = {flags: "flags"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      FLAGS_DOMAIN = [:none].freeze

      attr_reader :flags
    end
  end

  module Gio
    class ThemedIcon < GtkAst::GObject::Object
      include Icon

      TYPE = "Gio.ThemedIcon"
      GTYPE = "GThemedIcon"
      FIELDS = [:name, :names, :use_default_fallbacks].freeze
      PROPERTIES = {name: "name", names: "names", use_default_fallbacks: "use-default-fallbacks"}.freeze
      KEYS = (superclass::KEYS + Icon::FIELDS + FIELDS).uniq.freeze

      attr_reader :name, :names, :use_default_fallbacks
    end
  end

  module Gio
    class ThreadedResolver < Resolver

      TYPE = "Gio.ThreadedResolver"
      GTYPE = "GThreadedResolver"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class ThreadedSocketService < SocketService

      TYPE = "Gio.ThreadedSocketService"
      GTYPE = "GThreadedSocketService"
      FIELDS = [:max_threads].freeze
      PROPERTIES = {max_threads: "max-threads"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :max_threads
    end
  end

  module Gio
    class TlsCertificate < GtkAst::GObject::Object

      TYPE = "Gio.TlsCertificate"
      GTYPE = "GTlsCertificate"
      FIELDS = [:certificate, :certificate_pem, :dns_names, :ip_addresses, :issuer, :issuer_name, :not_valid_after, :not_valid_before, :password, :pkcs11_uri, :pkcs12_data, :private_key, :private_key_pem, :private_key_pkcs11_uri, :subject_name].freeze
      PROPERTIES = {certificate: "certificate", certificate_pem: "certificate-pem", dns_names: "dns-names", ip_addresses: "ip-addresses", issuer: "issuer", issuer_name: "issuer-name", not_valid_after: "not-valid-after", not_valid_before: "not-valid-before", password: "password", pkcs11_uri: "pkcs11-uri", pkcs12_data: "pkcs12-data", private_key: "private-key", private_key_pem: "private-key-pem", private_key_pkcs11_uri: "private-key-pkcs11-uri", subject_name: "subject-name"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :certificate, :certificate_pem, :dns_names, :ip_addresses, :issuer, :issuer_name, :not_valid_after, :not_valid_before, :password, :pkcs11_uri, :pkcs12_data, :private_key, :private_key_pem, :private_key_pkcs11_uri, :subject_name
    end
  end

  module Gio
    class TlsInteraction < GtkAst::GObject::Object

      TYPE = "Gio.TlsInteraction"
      GTYPE = "GTlsInteraction"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class TlsPassword < GtkAst::GObject::Object

      TYPE = "Gio.TlsPassword"
      GTYPE = "GTlsPassword"
      FIELDS = [:description, :flags, :warning].freeze
      PROPERTIES = {description: "description", flags: "flags", warning: "warning"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      FLAGS_DOMAIN = [:none, :retry, :many_tries, :final_try, :pkcs11_user, :pkcs11_security_officer, :pkcs11_context_specific].freeze

      attr_reader :description, :flags, :warning
    end
  end

  module Gio
    class UnixConnection < SocketConnection

      TYPE = "Gio.UnixConnection"
      GTYPE = "GUnixConnection"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class UnixCredentialsMessage < SocketControlMessage

      TYPE = "Gio.UnixCredentialsMessage"
      GTYPE = "GUnixCredentialsMessage"
      FIELDS = [:credentials].freeze
      PROPERTIES = {credentials: "credentials"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :credentials
    end
  end

  module Gio
    class UnixFDList < GtkAst::GObject::Object

      TYPE = "Gio.UnixFDList"
      GTYPE = "GUnixFDList"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class UnixSocketAddress < SocketAddress
      include SocketConnectable

      TYPE = "Gio.UnixSocketAddress"
      GTYPE = "GUnixSocketAddress"
      FIELDS = [:abstract, :address_type, :path, :path_as_array].freeze
      PROPERTIES = {abstract: "abstract", address_type: "address-type", path: "path", path_as_array: "path-as-array"}.freeze
      KEYS = (superclass::KEYS + SocketConnectable::FIELDS + FIELDS).uniq.freeze
      ADDRESS_TYPE_DOMAIN = [:invalid, :anonymous, :path, :abstract, :abstract_padded].freeze

      attr_reader :abstract, :address_type, :path, :path_as_array
    end
  end

  module Gio
    class Vfs < GtkAst::GObject::Object

      TYPE = "Gio.Vfs"
      GTYPE = "GVfs"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gio
    class ZlibCompressor < GtkAst::GObject::Object
      include Converter

      TYPE = "Gio.ZlibCompressor"
      GTYPE = "GZlibCompressor"
      FIELDS = [:file_info, :format, :level, :os].freeze
      PROPERTIES = {file_info: "file-info", format: "format", level: "level", os: "os"}.freeze
      KEYS = (superclass::KEYS + Converter::FIELDS + FIELDS).uniq.freeze
      FORMAT_DOMAIN = [:zlib, :gzip, :raw].freeze

      attr_reader :file_info, :format, :level, :os
    end
  end

  module Gio
    class ZlibDecompressor < GtkAst::GObject::Object
      include Converter

      TYPE = "Gio.ZlibDecompressor"
      GTYPE = "GZlibDecompressor"
      FIELDS = [:file_info, :format].freeze
      PROPERTIES = {file_info: "file-info", format: "format"}.freeze
      KEYS = (superclass::KEYS + Converter::FIELDS + FIELDS).uniq.freeze
      FORMAT_DOMAIN = [:zlib, :gzip, :raw].freeze

      attr_reader :file_info, :format
    end
  end

  module Gsk
    class RenderNode < GtkAst::Node

      TYPE = "Gsk.RenderNode"
      GTYPE = "GskRenderNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class BlendNode < RenderNode

      TYPE = "Gsk.BlendNode"
      GTYPE = "GskBlendNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class BlurNode < RenderNode

      TYPE = "Gsk.BlurNode"
      GTYPE = "GskBlurNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class BorderNode < RenderNode

      TYPE = "Gsk.BorderNode"
      GTYPE = "GskBorderNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class Renderer < GtkAst::GObject::Object

      TYPE = "Gsk.Renderer"
      GTYPE = "GskRenderer"
      FIELDS = [:realized, :surface].freeze
      PROPERTIES = {realized: "realized", surface: "surface"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :realized, :surface
    end
  end

  module Gsk
    class BroadwayRenderer < Renderer

      TYPE = "Gsk.BroadwayRenderer"
      GTYPE = "GskBroadwayRenderer"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class CairoNode < RenderNode

      TYPE = "Gsk.CairoNode"
      GTYPE = "GskCairoNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class CairoRenderer < Renderer

      TYPE = "Gsk.CairoRenderer"
      GTYPE = "GskCairoRenderer"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class ClipNode < RenderNode

      TYPE = "Gsk.ClipNode"
      GTYPE = "GskClipNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class ColorMatrixNode < RenderNode

      TYPE = "Gsk.ColorMatrixNode"
      GTYPE = "GskColorMatrixNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class ColorNode < RenderNode

      TYPE = "Gsk.ColorNode"
      GTYPE = "GskColorNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class ComponentTransferNode < RenderNode

      TYPE = "Gsk.ComponentTransferNode"
      GTYPE = "GskComponentTransferNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class CompositeNode < RenderNode

      TYPE = "Gsk.CompositeNode"
      GTYPE = "GskCompositeNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class ConicGradientNode < RenderNode

      TYPE = "Gsk.ConicGradientNode"
      GTYPE = "GskConicGradientNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class ContainerNode < RenderNode

      TYPE = "Gsk.ContainerNode"
      GTYPE = "GskContainerNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class CopyNode < RenderNode

      TYPE = "Gsk.CopyNode"
      GTYPE = "GskCopyNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class CrossFadeNode < RenderNode

      TYPE = "Gsk.CrossFadeNode"
      GTYPE = "GskCrossFadeNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class DebugNode < RenderNode

      TYPE = "Gsk.DebugNode"
      GTYPE = "GskDebugNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class FillNode < RenderNode

      TYPE = "Gsk.FillNode"
      GTYPE = "GskFillNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class GLRenderer < Renderer

      TYPE = "Gsk.GLRenderer"
      GTYPE = "GskGLRenderer"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class GLShader < GtkAst::GObject::Object

      TYPE = "Gsk.GLShader"
      GTYPE = "GskGLShader"
      FIELDS = [:resource, :source].freeze
      PROPERTIES = {resource: "resource", source: "source"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :resource, :source
    end
  end

  module Gsk
    class GLShaderNode < RenderNode

      TYPE = "Gsk.GLShaderNode"
      GTYPE = "GskGLShaderNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class InsetShadowNode < RenderNode

      TYPE = "Gsk.InsetShadowNode"
      GTYPE = "GskInsetShadowNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class IsolationNode < RenderNode

      TYPE = "Gsk.IsolationNode"
      GTYPE = "GskIsolationNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class LinearGradientNode < RenderNode

      TYPE = "Gsk.LinearGradientNode"
      GTYPE = "GskLinearGradientNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class MaskNode < RenderNode

      TYPE = "Gsk.MaskNode"
      GTYPE = "GskMaskNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class NglRenderer < Renderer

      TYPE = "Gsk.NglRenderer"
      GTYPE = "GskNglRenderer"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class OpacityNode < RenderNode

      TYPE = "Gsk.OpacityNode"
      GTYPE = "GskOpacityNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class OutsetShadowNode < RenderNode

      TYPE = "Gsk.OutsetShadowNode"
      GTYPE = "GskOutsetShadowNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class PasteNode < RenderNode

      TYPE = "Gsk.PasteNode"
      GTYPE = "GskPasteNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class RadialGradientNode < RenderNode

      TYPE = "Gsk.RadialGradientNode"
      GTYPE = "GskRadialGradientNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class RepeatNode < RenderNode

      TYPE = "Gsk.RepeatNode"
      GTYPE = "GskRepeatNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class RepeatingLinearGradientNode < RenderNode

      TYPE = "Gsk.RepeatingLinearGradientNode"
      GTYPE = "GskRepeatingLinearGradientNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class RepeatingRadialGradientNode < RenderNode

      TYPE = "Gsk.RepeatingRadialGradientNode"
      GTYPE = "GskRepeatingRadialGradientNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class RoundedClipNode < RenderNode

      TYPE = "Gsk.RoundedClipNode"
      GTYPE = "GskRoundedClipNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class ShadowNode < RenderNode

      TYPE = "Gsk.ShadowNode"
      GTYPE = "GskShadowNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class StrokeNode < RenderNode

      TYPE = "Gsk.StrokeNode"
      GTYPE = "GskStrokeNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class SubsurfaceNode < RenderNode

      TYPE = "Gsk.SubsurfaceNode"
      GTYPE = "GskSubsurfaceNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class TextNode < RenderNode

      TYPE = "Gsk.TextNode"
      GTYPE = "GskTextNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class TextureNode < RenderNode

      TYPE = "Gsk.TextureNode"
      GTYPE = "GskTextureNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class TextureScaleNode < RenderNode

      TYPE = "Gsk.TextureScaleNode"
      GTYPE = "GskTextureScaleNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class TransformNode < RenderNode

      TYPE = "Gsk.TransformNode"
      GTYPE = "GskTransformNode"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gsk
    class VulkanRenderer < Renderer

      TYPE = "Gsk.VulkanRenderer"
      GTYPE = "GskVulkanRenderer"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class ATContext < GtkAst::GObject::Object

      TYPE = "Gtk.ATContext"
      GTYPE = "GtkATContext"
      FIELDS = [:accessible, :accessible_role, :display, :realized].freeze
      PROPERTIES = {accessible: "accessible", accessible_role: "accessible-role", display: "display", realized: "realized"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      ACCESSIBLE_ROLE_DOMAIN = [:alert, :alert_dialog, :banner, :button, :caption, :cell, :checkbox, :column_header, :combo_box, :command, :composite, :dialog, :document, :feed, :form, :generic, :grid, :grid_cell, :group, :heading, :img, :input, :label, :landmark, :legend, :link, :list, :list_box, :list_item, :log, :main, :marquee, :math, :meter, :menu, :menu_bar, :menu_item, :menu_item_checkbox, :menu_item_radio, :navigation, :none, :note, :option, :presentation, :progress_bar, :radio, :radio_group, :range, :region, :row, :row_group, :row_header, :scrollbar, :search, :search_box, :section, :section_head, :select, :separator, :slider, :spin_button, :status, :structure, :switch, :tab, :table, :tab_list, :tab_panel, :text_box, :time, :timer, :toolbar, :tooltip, :tree, :tree_grid, :tree_item, :widget, :window, :toggle_button, :application, :paragraph, :block_quote, :article, :comment, :terminal].freeze

      attr_reader :accessible, :accessible_role, :display, :realized
    end
  end

  module Gtk
    class AboutDialog < Window
      include Accessible
      include Buildable
      include ConstraintTarget
      include Native
      include Root
      include ShortcutManager

      TYPE = "Gtk.AboutDialog"
      GTYPE = "GtkAboutDialog"
      FIELDS = [:artists, :authors, :comments, :copyright, :documenters, :license, :license_type, :logo, :logo_icon_name, :program_name, :system_information, :translator_credits, :version, :website, :website_label, :wrap_license].freeze
      PROPERTIES = {artists: "artists", authors: "authors", comments: "comments", copyright: "copyright", documenters: "documenters", license: "license", license_type: "license-type", logo: "logo", logo_icon_name: "logo-icon-name", program_name: "program-name", system_information: "system-information", translator_credits: "translator-credits", version: "version", website: "website", website_label: "website-label", wrap_license: "wrap-license"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + Root::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze
      LICENSE_TYPE_DOMAIN = [:unknown, :custom, :gpl_2_0, :gpl_3_0, :lgpl_2_1, :lgpl_3_0, :bsd, :mit_x11, :artistic, :gpl_2_0_only, :gpl_3_0_only, :lgpl_2_1_only, :lgpl_3_0_only, :agpl_3_0, :agpl_3_0_only, :bsd_3, :apache_2_0, :mpl_2_0, :"0bsd"].freeze

      attr_reader :artists, :authors, :comments, :copyright, :documenters, :license, :license_type, :logo, :logo_icon_name, :program_name, :system_information, :translator_credits, :version, :website, :website_label, :wrap_license
    end
  end

  module Gtk
    class AccessibleHyperlink < GtkAst::GObject::Object
      include Accessible

      TYPE = "Gtk.AccessibleHyperlink"
      GTYPE = "GtkAccessibleHyperlink"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class ActionBar < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.ActionBar"
      GTYPE = "GtkActionBar"
      FIELDS = [:revealed].freeze
      PROPERTIES = {revealed: "revealed"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :revealed
    end
  end

  module Gtk
    class ShortcutAction < GtkAst::GObject::Object

      TYPE = "Gtk.ShortcutAction"
      GTYPE = "GtkShortcutAction"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class ActivateAction < ShortcutAction

      TYPE = "Gtk.ActivateAction"
      GTYPE = "GtkActivateAction"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class Adjustment < GtkAst::GObject::InitiallyUnowned

      TYPE = "Gtk.Adjustment"
      GTYPE = "GtkAdjustment"
      FIELDS = [:lower, :page_increment, :page_size, :step_increment, :upper, :value].freeze
      PROPERTIES = {lower: "lower", page_increment: "page-increment", page_size: "page-size", step_increment: "step-increment", upper: "upper", value: "value"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :lower, :page_increment, :page_size, :step_increment, :upper, :value
    end
  end

  module Gtk
    class AlertDialog < GtkAst::GObject::Object

      TYPE = "Gtk.AlertDialog"
      GTYPE = "GtkAlertDialog"
      FIELDS = [:buttons, :cancel_button, :default_button, :detail, :message, :modal].freeze
      PROPERTIES = {buttons: "buttons", cancel_button: "cancel-button", default_button: "default-button", detail: "detail", message: "message", modal: "modal"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :buttons, :cancel_button, :default_button, :detail, :message, :modal
    end
  end

  module Gtk
    class ShortcutTrigger < GtkAst::GObject::Object

      TYPE = "Gtk.ShortcutTrigger"
      GTYPE = "GtkShortcutTrigger"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class AlternativeTrigger < ShortcutTrigger

      TYPE = "Gtk.AlternativeTrigger"
      GTYPE = "GtkAlternativeTrigger"
      FIELDS = [:first, :second].freeze
      PROPERTIES = {first: "first", second: "second"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :first, :second
    end
  end

  module Gtk
    class Filter < GtkAst::GObject::Object

      TYPE = "Gtk.Filter"
      GTYPE = "GtkFilter"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class MultiFilter < Filter
      include GtkAst::Gio::ListModel
      include Buildable

      TYPE = "Gtk.MultiFilter"
      GTYPE = "GtkMultiFilter"
      FIELDS = [:item_type, :n_items].freeze
      PROPERTIES = {item_type: "item-type", n_items: "n-items"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + Buildable::FIELDS + FIELDS).uniq.freeze

      attr_reader :item_type, :n_items
    end
  end

  module Gtk
    class AnyFilter < MultiFilter
      include GtkAst::Gio::ListModel
      include Buildable

      TYPE = "Gtk.AnyFilter"
      GTYPE = "GtkAnyFilter"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + Buildable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class AppChooserButton < Widget
      include Accessible
      include AppChooser
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.AppChooserButton"
      GTYPE = "GtkAppChooserButton"
      FIELDS = [:heading, :modal, :show_default_item, :show_dialog_item].freeze
      PROPERTIES = {heading: "heading", modal: "modal", show_default_item: "show-default-item", show_dialog_item: "show-dialog-item"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AppChooser::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :heading, :modal, :show_default_item, :show_dialog_item
    end
  end

  module Gtk
    class Dialog < Window
      include Accessible
      include Buildable
      include ConstraintTarget
      include Native
      include Root
      include ShortcutManager

      TYPE = "Gtk.Dialog"
      GTYPE = "GtkDialog"
      FIELDS = [:use_header_bar].freeze
      PROPERTIES = {use_header_bar: "use-header-bar"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + Root::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze

      attr_reader :use_header_bar
    end
  end

  module Gtk
    class AppChooserDialog < Dialog
      include Accessible
      include AppChooser
      include Buildable
      include ConstraintTarget
      include Native
      include Root
      include ShortcutManager

      TYPE = "Gtk.AppChooserDialog"
      GTYPE = "GtkAppChooserDialog"
      FIELDS = [:gfile, :heading].freeze
      PROPERTIES = {gfile: "gfile", heading: "heading"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AppChooser::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + Root::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze

      attr_reader :gfile, :heading
    end
  end

  module Gtk
    class AppChooserWidget < Widget
      include Accessible
      include AppChooser
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.AppChooserWidget"
      GTYPE = "GtkAppChooserWidget"
      FIELDS = [:default_text, :show_all, :show_default, :show_fallback, :show_other, :show_recommended].freeze
      PROPERTIES = {default_text: "default-text", show_all: "show-all", show_default: "show-default", show_fallback: "show-fallback", show_other: "show-other", show_recommended: "show-recommended"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AppChooser::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :default_text, :show_all, :show_default, :show_fallback, :show_other, :show_recommended
    end
  end

  module Gtk
    class AspectFrame < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.AspectFrame"
      GTYPE = "GtkAspectFrame"
      FIELDS = [:child, :obey_child, :ratio, :xalign, :yalign].freeze
      PROPERTIES = {child: "child", obey_child: "obey-child", ratio: "ratio", xalign: "xalign", yalign: "yalign"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :child, :obey_child, :ratio, :xalign, :yalign
    end
  end

  module Gtk
    class Assistant < Window
      include Accessible
      include Buildable
      include ConstraintTarget
      include Native
      include Root
      include ShortcutManager

      TYPE = "Gtk.Assistant"
      GTYPE = "GtkAssistant"
      FIELDS = [:pages, :use_header_bar].freeze
      PROPERTIES = {pages: "pages", use_header_bar: "use-header-bar"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + Root::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze

      attr_reader :pages, :use_header_bar
    end
  end

  module Gtk
    class AssistantPage < GtkAst::GObject::Object

      TYPE = "Gtk.AssistantPage"
      GTYPE = "GtkAssistantPage"
      FIELDS = [:child, :complete, :page_type, :title].freeze
      PROPERTIES = {child: "child", complete: "complete", page_type: "page-type", title: "title"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      PAGE_TYPE_DOMAIN = [:content, :intro, :confirm, :summary, :progress, :custom].freeze

      attr_reader :child, :complete, :page_type, :title
    end
  end

  module Gtk
    class BinLayout < LayoutManager

      TYPE = "Gtk.BinLayout"
      GTYPE = "GtkBinLayout"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class BookmarkList < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel

      TYPE = "Gtk.BookmarkList"
      GTYPE = "GtkBookmarkList"
      FIELDS = [:attributes, :filename, :io_priority, :item_type, :loading, :n_items].freeze
      PROPERTIES = {attributes: "attributes", filename: "filename", io_priority: "io-priority", item_type: "item-type", loading: "loading", n_items: "n-items"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :attributes, :filename, :io_priority, :item_type, :loading, :n_items
    end
  end

  module Gtk
    class BoolFilter < Filter

      TYPE = "Gtk.BoolFilter"
      GTYPE = "GtkBoolFilter"
      FIELDS = [:expression, :invert].freeze
      PROPERTIES = {expression: "expression", invert: "invert"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :expression, :invert
    end
  end

  module Gtk
    class Box < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.Box"
      GTYPE = "GtkBox"
      FIELDS = [:baseline_child, :baseline_position, :homogeneous, :spacing].freeze
      PROPERTIES = {baseline_child: "baseline-child", baseline_position: "baseline-position", homogeneous: "homogeneous", spacing: "spacing"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze
      BASELINE_POSITION_DOMAIN = [:top, :center, :bottom].freeze

      attr_reader :baseline_child, :baseline_position, :homogeneous, :spacing
    end
  end

  module Gtk
    class BoxLayout < LayoutManager
      include Orientable

      TYPE = "Gtk.BoxLayout"
      GTYPE = "GtkBoxLayout"
      FIELDS = [:baseline_child, :baseline_position, :homogeneous, :spacing].freeze
      PROPERTIES = {baseline_child: "baseline-child", baseline_position: "baseline-position", homogeneous: "homogeneous", spacing: "spacing"}.freeze
      KEYS = (superclass::KEYS + Orientable::FIELDS + FIELDS).uniq.freeze
      BASELINE_POSITION_DOMAIN = [:top, :center, :bottom].freeze

      attr_reader :baseline_child, :baseline_position, :homogeneous, :spacing
    end
  end

  module Gtk
    class Builder < GtkAst::GObject::Object

      TYPE = "Gtk.Builder"
      GTYPE = "GtkBuilder"
      FIELDS = [:current_object, :scope, :translation_domain].freeze
      PROPERTIES = {current_object: "current-object", scope: "scope", translation_domain: "translation-domain"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :current_object, :scope, :translation_domain
    end
  end

  module Gtk
    class BuilderCScope < GtkAst::GObject::Object
      include BuilderScope

      TYPE = "Gtk.BuilderCScope"
      GTYPE = "GtkBuilderCScope"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + BuilderScope::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class ListItemFactory < GtkAst::GObject::Object

      TYPE = "Gtk.ListItemFactory"
      GTYPE = "GtkListItemFactory"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class BuilderListItemFactory < ListItemFactory

      TYPE = "Gtk.BuilderListItemFactory"
      GTYPE = "GtkBuilderListItemFactory"
      FIELDS = [:bytes, :resource, :scope].freeze
      PROPERTIES = {bytes: "bytes", resource: "resource", scope: "scope"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :bytes, :resource, :scope
    end
  end

  module Gtk
    class Button < Widget
      include Accessible
      include Actionable
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Button"
      GTYPE = "GtkButton"
      FIELDS = [:can_shrink, :child, :has_frame, :icon_name, :label, :use_underline].freeze
      PROPERTIES = {can_shrink: "can-shrink", child: "child", has_frame: "has-frame", icon_name: "icon-name", label: "label", use_underline: "use-underline"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Actionable::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :can_shrink, :child, :has_frame, :icon_name, :label, :use_underline
    end
  end

  module Gtk
    class Expression < GtkAst::Node

      TYPE = "Gtk.Expression"
      GTYPE = "GtkExpression"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class CClosureExpression < Expression

      TYPE = "Gtk.CClosureExpression"
      GTYPE = "GtkCClosureExpression"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class Calendar < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Calendar"
      GTYPE = "GtkCalendar"
      FIELDS = [:date, :day, :month, :show_day_names, :show_heading, :show_week_numbers, :year].freeze
      PROPERTIES = {date: "date", day: "day", month: "month", show_day_names: "show-day-names", show_heading: "show-heading", show_week_numbers: "show-week-numbers", year: "year"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :date, :day, :month, :show_day_names, :show_heading, :show_week_numbers, :year
    end
  end

  module Gtk
    class CallbackAction < ShortcutAction

      TYPE = "Gtk.CallbackAction"
      GTYPE = "GtkCallbackAction"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class CellArea < GtkAst::GObject::InitiallyUnowned
      include Buildable
      include CellLayout

      TYPE = "Gtk.CellArea"
      GTYPE = "GtkCellArea"
      FIELDS = [:edit_widget, :edited_cell, :focus_cell].freeze
      PROPERTIES = {edit_widget: "edit-widget", edited_cell: "edited-cell", focus_cell: "focus-cell"}.freeze
      KEYS = (superclass::KEYS + Buildable::FIELDS + CellLayout::FIELDS + FIELDS).uniq.freeze

      attr_reader :edit_widget, :edited_cell, :focus_cell
    end
  end

  module Gtk
    class CellAreaBox < CellArea
      include Buildable
      include CellLayout
      include Orientable

      TYPE = "Gtk.CellAreaBox"
      GTYPE = "GtkCellAreaBox"
      FIELDS = [:spacing].freeze
      PROPERTIES = {spacing: "spacing"}.freeze
      KEYS = (superclass::KEYS + Buildable::FIELDS + CellLayout::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :spacing
    end
  end

  module Gtk
    class CellAreaContext < GtkAst::GObject::Object

      TYPE = "Gtk.CellAreaContext"
      GTYPE = "GtkCellAreaContext"
      FIELDS = [:area, :minimum_height, :minimum_width, :natural_height, :natural_width].freeze
      PROPERTIES = {area: "area", minimum_height: "minimum-height", minimum_width: "minimum-width", natural_height: "natural-height", natural_width: "natural-width"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :area, :minimum_height, :minimum_width, :natural_height, :natural_width
    end
  end

  module Gtk
    class CellRenderer < GtkAst::GObject::InitiallyUnowned

      TYPE = "Gtk.CellRenderer"
      GTYPE = "GtkCellRenderer"
      FIELDS = [:cell_background, :cell_background_rgba, :cell_background_set, :editing, :height, :is_expanded, :is_expander, :mode, :sensitive, :visible, :width, :xalign, :xpad, :yalign, :ypad].freeze
      PROPERTIES = {cell_background: "cell-background", cell_background_rgba: "cell-background-rgba", cell_background_set: "cell-background-set", editing: "editing", height: "height", is_expanded: "is-expanded", is_expander: "is-expander", mode: "mode", sensitive: "sensitive", visible: "visible", width: "width", xalign: "xalign", xpad: "xpad", yalign: "yalign", ypad: "ypad"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      MODE_DOMAIN = [:inert, :activatable, :editable].freeze

      attr_reader :cell_background, :cell_background_rgba, :cell_background_set, :editing, :height, :is_expanded, :is_expander, :mode, :sensitive, :visible, :width, :xalign, :xpad, :yalign, :ypad
    end
  end

  module Gtk
    class CellRendererText < CellRenderer

      TYPE = "Gtk.CellRendererText"
      GTYPE = "GtkCellRendererText"
      FIELDS = [:align_set, :alignment, :attributes, :background, :background_rgba, :background_set, :editable, :editable_set, :ellipsize, :ellipsize_set, :family, :family_set, :font, :font_desc, :foreground, :foreground_rgba, :foreground_set, :language, :language_set, :markup, :max_width_chars, :placeholder_text, :rise, :rise_set, :scale, :scale_set, :single_paragraph_mode, :size, :size_points, :size_set, :stretch, :stretch_set, :strikethrough, :strikethrough_set, :style, :style_set, :text, :underline, :underline_set, :variant, :variant_set, :weight, :weight_set, :width_chars, :wrap_mode, :wrap_width].freeze
      PROPERTIES = {align_set: "align-set", alignment: "alignment", attributes: "attributes", background: "background", background_rgba: "background-rgba", background_set: "background-set", editable: "editable", editable_set: "editable-set", ellipsize: "ellipsize", ellipsize_set: "ellipsize-set", family: "family", family_set: "family-set", font: "font", font_desc: "font-desc", foreground: "foreground", foreground_rgba: "foreground-rgba", foreground_set: "foreground-set", language: "language", language_set: "language-set", markup: "markup", max_width_chars: "max-width-chars", placeholder_text: "placeholder-text", rise: "rise", rise_set: "rise-set", scale: "scale", scale_set: "scale-set", single_paragraph_mode: "single-paragraph-mode", size: "size", size_points: "size-points", size_set: "size-set", stretch: "stretch", stretch_set: "stretch-set", strikethrough: "strikethrough", strikethrough_set: "strikethrough-set", style: "style", style_set: "style-set", text: "text", underline: "underline", underline_set: "underline-set", variant: "variant", variant_set: "variant-set", weight: "weight", weight_set: "weight-set", width_chars: "width-chars", wrap_mode: "wrap-mode", wrap_width: "wrap-width"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      ALIGNMENT_DOMAIN = [:left, :center, :right].freeze
      ELLIPSIZE_DOMAIN = [:none, :start, :middle, :end].freeze
      STRETCH_DOMAIN = [:ultra_condensed, :extra_condensed, :condensed, :semi_condensed, :normal, :semi_expanded, :expanded, :extra_expanded, :ultra_expanded].freeze
      STYLE_DOMAIN = [:normal, :oblique, :italic].freeze
      UNDERLINE_DOMAIN = [:none, :single, :double, :low, :error, :single_line, :double_line, :error_line].freeze
      VARIANT_DOMAIN = [:normal, :small_caps, :all_small_caps, :petite_caps, :all_petite_caps, :unicase, :title_caps].freeze
      WRAP_MODE_DOMAIN = [:word, :char, :word_char, :none].freeze

      attr_reader :align_set, :alignment, :attributes, :background, :background_rgba, :background_set, :editable, :editable_set, :ellipsize, :ellipsize_set, :family, :family_set, :font, :font_desc, :foreground, :foreground_rgba, :foreground_set, :language, :language_set, :markup, :max_width_chars, :placeholder_text, :rise, :rise_set, :scale, :scale_set, :single_paragraph_mode, :size, :size_points, :size_set, :stretch, :stretch_set, :strikethrough, :strikethrough_set, :style, :style_set, :text, :underline, :underline_set, :variant, :variant_set, :weight, :weight_set, :width_chars, :wrap_mode, :wrap_width
    end
  end

  module Gtk
    class CellRendererAccel < CellRendererText

      TYPE = "Gtk.CellRendererAccel"
      GTYPE = "GtkCellRendererAccel"
      FIELDS = [:accel_key, :accel_mode, :accel_mods, :keycode].freeze
      PROPERTIES = {accel_key: "accel-key", accel_mode: "accel-mode", accel_mods: "accel-mods", keycode: "keycode"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      ACCEL_MODE_DOMAIN = [:gtk, :other].freeze
      ACCEL_MODS_DOMAIN = [:no_modifier_mask, :shift_mask, :lock_mask, :control_mask, :alt_mask, :button1_mask, :button2_mask, :button3_mask, :button4_mask, :button5_mask, :super_mask, :hyper_mask, :meta_mask].freeze

      attr_reader :accel_key, :accel_mode, :accel_mods, :keycode
    end
  end

  module Gtk
    class CellRendererCombo < CellRendererText

      TYPE = "Gtk.CellRendererCombo"
      GTYPE = "GtkCellRendererCombo"
      FIELDS = [:has_entry, :model, :text_column].freeze
      PROPERTIES = {has_entry: "has-entry", model: "model", text_column: "text-column"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :has_entry, :model, :text_column
    end
  end

  module Gtk
    class CellRendererPixbuf < CellRenderer

      TYPE = "Gtk.CellRendererPixbuf"
      GTYPE = "GtkCellRendererPixbuf"
      FIELDS = [:gicon, :icon_name, :icon_size, :pixbuf, :pixbuf_expander_closed, :pixbuf_expander_open, :texture].freeze
      PROPERTIES = {gicon: "gicon", icon_name: "icon-name", icon_size: "icon-size", pixbuf: "pixbuf", pixbuf_expander_closed: "pixbuf-expander-closed", pixbuf_expander_open: "pixbuf-expander-open", texture: "texture"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      ICON_SIZE_DOMAIN = [:inherit, :normal, :large].freeze

      attr_reader :gicon, :icon_name, :icon_size, :pixbuf, :pixbuf_expander_closed, :pixbuf_expander_open, :texture
    end
  end

  module Gtk
    class CellRendererProgress < CellRenderer
      include Orientable

      TYPE = "Gtk.CellRendererProgress"
      GTYPE = "GtkCellRendererProgress"
      FIELDS = [:inverted, :pulse, :text, :text_xalign, :text_yalign, :value].freeze
      PROPERTIES = {inverted: "inverted", pulse: "pulse", text: "text", text_xalign: "text-xalign", text_yalign: "text-yalign", value: "value"}.freeze
      KEYS = (superclass::KEYS + Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :inverted, :pulse, :text, :text_xalign, :text_yalign, :value
    end
  end

  module Gtk
    class CellRendererSpin < CellRendererText

      TYPE = "Gtk.CellRendererSpin"
      GTYPE = "GtkCellRendererSpin"
      FIELDS = [:adjustment, :climb_rate, :digits].freeze
      PROPERTIES = {adjustment: "adjustment", climb_rate: "climb-rate", digits: "digits"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :adjustment, :climb_rate, :digits
    end
  end

  module Gtk
    class CellRendererSpinner < CellRenderer

      TYPE = "Gtk.CellRendererSpinner"
      GTYPE = "GtkCellRendererSpinner"
      FIELDS = [:active, :pulse, :size].freeze
      PROPERTIES = {active: "active", pulse: "pulse", size: "size"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      SIZE_DOMAIN = [:inherit, :normal, :large].freeze

      attr_reader :active, :pulse, :size
    end
  end

  module Gtk
    class CellRendererToggle < CellRenderer

      TYPE = "Gtk.CellRendererToggle"
      GTYPE = "GtkCellRendererToggle"
      FIELDS = [:activatable, :active, :inconsistent, :radio].freeze
      PROPERTIES = {activatable: "activatable", active: "active", inconsistent: "inconsistent", radio: "radio"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :activatable, :active, :inconsistent, :radio
    end
  end

  module Gtk
    class CellView < Widget
      include Accessible
      include Buildable
      include CellLayout
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.CellView"
      GTYPE = "GtkCellView"
      FIELDS = [:cell_area, :cell_area_context, :draw_sensitive, :fit_model, :model].freeze
      PROPERTIES = {cell_area: "cell-area", cell_area_context: "cell-area-context", draw_sensitive: "draw-sensitive", fit_model: "fit-model", model: "model"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + CellLayout::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :cell_area, :cell_area_context, :draw_sensitive, :fit_model, :model
    end
  end

  module Gtk
    class CenterBox < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.CenterBox"
      GTYPE = "GtkCenterBox"
      FIELDS = [:baseline_position, :center_widget, :end_widget, :shrink_center_last, :start_widget].freeze
      PROPERTIES = {baseline_position: "baseline-position", center_widget: "center-widget", end_widget: "end-widget", shrink_center_last: "shrink-center-last", start_widget: "start-widget"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze
      BASELINE_POSITION_DOMAIN = [:top, :center, :bottom].freeze

      attr_reader :baseline_position, :center_widget, :end_widget, :shrink_center_last, :start_widget
    end
  end

  module Gtk
    class CenterLayout < LayoutManager

      TYPE = "Gtk.CenterLayout"
      GTYPE = "GtkCenterLayout"
      FIELDS = [:shrink_center_last].freeze
      PROPERTIES = {shrink_center_last: "shrink-center-last"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :shrink_center_last
    end
  end

  module Gtk
    class CheckButton < Widget
      include Accessible
      include Actionable
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.CheckButton"
      GTYPE = "GtkCheckButton"
      FIELDS = [:active, :child, :group, :inconsistent, :label, :use_underline].freeze
      PROPERTIES = {active: "active", child: "child", group: "group", inconsistent: "inconsistent", label: "label", use_underline: "use-underline"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Actionable::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :active, :child, :group, :inconsistent, :label, :use_underline
    end
  end

  module Gtk
    class ClosureExpression < Expression

      TYPE = "Gtk.ClosureExpression"
      GTYPE = "GtkClosureExpression"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class ColorButton < Widget
      include Accessible
      include Buildable
      include ColorChooser
      include ConstraintTarget

      TYPE = "Gtk.ColorButton"
      GTYPE = "GtkColorButton"
      FIELDS = [:modal, :show_editor, :title].freeze
      PROPERTIES = {modal: "modal", show_editor: "show-editor", title: "title"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ColorChooser::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :modal, :show_editor, :title
    end
  end

  module Gtk
    class ColorChooserDialog < Dialog
      include Accessible
      include Buildable
      include ColorChooser
      include ConstraintTarget
      include Native
      include Root
      include ShortcutManager

      TYPE = "Gtk.ColorChooserDialog"
      GTYPE = "GtkColorChooserDialog"
      FIELDS = [:show_editor].freeze
      PROPERTIES = {show_editor: "show-editor"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ColorChooser::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + Root::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze

      attr_reader :show_editor
    end
  end

  module Gtk
    class ColorChooserWidget < Widget
      include Accessible
      include Buildable
      include ColorChooser
      include ConstraintTarget

      TYPE = "Gtk.ColorChooserWidget"
      GTYPE = "GtkColorChooserWidget"
      FIELDS = [:show_editor].freeze
      PROPERTIES = {show_editor: "show-editor"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ColorChooser::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :show_editor
    end
  end

  module Gtk
    class ColorDialog < GtkAst::GObject::Object

      TYPE = "Gtk.ColorDialog"
      GTYPE = "GtkColorDialog"
      FIELDS = [:modal, :title, :with_alpha].freeze
      PROPERTIES = {modal: "modal", title: "title", with_alpha: "with-alpha"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :modal, :title, :with_alpha
    end
  end

  module Gtk
    class ColorDialogButton < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.ColorDialogButton"
      GTYPE = "GtkColorDialogButton"
      FIELDS = [:dialog, :rgba].freeze
      PROPERTIES = {dialog: "dialog", rgba: "rgba"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :dialog, :rgba
    end
  end

  module Gtk
    class ColumnView < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Scrollable

      TYPE = "Gtk.ColumnView"
      GTYPE = "GtkColumnView"
      FIELDS = [:columns, :enable_rubberband, :header_factory, :model, :reorderable, :row_factory, :show_column_separators, :show_row_separators, :single_click_activate, :sorter, :tab_behavior].freeze
      PROPERTIES = {columns: "columns", enable_rubberband: "enable-rubberband", header_factory: "header-factory", model: "model", reorderable: "reorderable", row_factory: "row-factory", show_column_separators: "show-column-separators", show_row_separators: "show-row-separators", single_click_activate: "single-click-activate", sorter: "sorter", tab_behavior: "tab-behavior"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Scrollable::FIELDS + FIELDS).uniq.freeze
      TAB_BEHAVIOR_DOMAIN = [:all, :item, :cell].freeze

      attr_reader :columns, :enable_rubberband, :header_factory, :model, :reorderable, :row_factory, :show_column_separators, :show_row_separators, :single_click_activate, :sorter, :tab_behavior
    end
  end

  module Gtk
    class ListItem < GtkAst::GObject::Object

      TYPE = "Gtk.ListItem"
      GTYPE = "GtkListItem"
      FIELDS = [:accessible_description, :accessible_label, :activatable, :child, :focusable, :item, :position, :selectable, :selected].freeze
      PROPERTIES = {accessible_description: "accessible-description", accessible_label: "accessible-label", activatable: "activatable", child: "child", focusable: "focusable", item: "item", position: "position", selectable: "selectable", selected: "selected"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :accessible_description, :accessible_label, :activatable, :child, :focusable, :item, :position, :selectable, :selected
    end
  end

  module Gtk
    class ColumnViewCell < ListItem

      TYPE = "Gtk.ColumnViewCell"
      GTYPE = "GtkColumnViewCell"
      FIELDS = [:child, :focusable, :item, :position, :selected].freeze
      PROPERTIES = {child: "child", focusable: "focusable", item: "item", position: "position", selected: "selected"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :child, :focusable, :item, :position, :selected
    end
  end

  module Gtk
    class ColumnViewColumn < GtkAst::GObject::Object

      TYPE = "Gtk.ColumnViewColumn"
      GTYPE = "GtkColumnViewColumn"
      FIELDS = [:column_view, :expand, :factory, :fixed_width, :header_menu, :id, :resizable, :sorter, :title, :visible].freeze
      PROPERTIES = {column_view: "column-view", expand: "expand", factory: "factory", fixed_width: "fixed-width", header_menu: "header-menu", id: "id", resizable: "resizable", sorter: "sorter", title: "title", visible: "visible"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :column_view, :expand, :factory, :fixed_width, :header_menu, :id, :resizable, :sorter, :title, :visible
    end
  end

  module Gtk
    class ColumnViewRow < GtkAst::GObject::Object

      TYPE = "Gtk.ColumnViewRow"
      GTYPE = "GtkColumnViewRow"
      FIELDS = [:accessible_description, :accessible_label, :activatable, :focusable, :item, :position, :selectable, :selected].freeze
      PROPERTIES = {accessible_description: "accessible-description", accessible_label: "accessible-label", activatable: "activatable", focusable: "focusable", item: "item", position: "position", selectable: "selectable", selected: "selected"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :accessible_description, :accessible_label, :activatable, :focusable, :item, :position, :selectable, :selected
    end
  end

  module Gtk
    class Sorter < GtkAst::GObject::Object

      TYPE = "Gtk.Sorter"
      GTYPE = "GtkSorter"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class ColumnViewSorter < Sorter

      TYPE = "Gtk.ColumnViewSorter"
      GTYPE = "GtkColumnViewSorter"
      FIELDS = [:primary_sort_column, :primary_sort_order].freeze
      PROPERTIES = {primary_sort_column: "primary-sort-column", primary_sort_order: "primary-sort-order"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      PRIMARY_SORT_ORDER_DOMAIN = [:ascending, :descending].freeze

      attr_reader :primary_sort_column, :primary_sort_order
    end
  end

  module Gtk
    class ComboBox < Widget
      include Accessible
      include Buildable
      include CellEditable
      include CellLayout
      include ConstraintTarget

      TYPE = "Gtk.ComboBox"
      GTYPE = "GtkComboBox"
      FIELDS = [:active, :active_id, :button_sensitivity, :child, :entry_text_column, :has_entry, :has_frame, :id_column, :model, :popup_fixed_width, :popup_shown].freeze
      PROPERTIES = {active: "active", active_id: "active-id", button_sensitivity: "button-sensitivity", child: "child", entry_text_column: "entry-text-column", has_entry: "has-entry", has_frame: "has-frame", id_column: "id-column", model: "model", popup_fixed_width: "popup-fixed-width", popup_shown: "popup-shown"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + CellEditable::FIELDS + CellLayout::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      BUTTON_SENSITIVITY_DOMAIN = [:auto, :on, :off].freeze

      attr_reader :active, :active_id, :button_sensitivity, :child, :entry_text_column, :has_entry, :has_frame, :id_column, :model, :popup_fixed_width, :popup_shown
    end
  end

  module Gtk
    class ComboBoxText < ComboBox
      include Accessible
      include Buildable
      include CellEditable
      include CellLayout
      include ConstraintTarget

      TYPE = "Gtk.ComboBoxText"
      GTYPE = "GtkComboBoxText"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + CellEditable::FIELDS + CellLayout::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class ConstantExpression < Expression

      TYPE = "Gtk.ConstantExpression"
      GTYPE = "GtkConstantExpression"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class Constraint < GtkAst::GObject::Object

      TYPE = "Gtk.Constraint"
      GTYPE = "GtkConstraint"
      FIELDS = [:constant, :multiplier, :relation, :source, :source_attribute, :strength, :target, :target_attribute].freeze
      PROPERTIES = {constant: "constant", multiplier: "multiplier", relation: "relation", source: "source", source_attribute: "source-attribute", strength: "strength", target: "target", target_attribute: "target-attribute"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      RELATION_DOMAIN = [:le, :eq, :ge].freeze
      SOURCE_ATTRIBUTE_DOMAIN = [:none, :left, :right, :top, :bottom, :start, :end, :width, :height, :center_x, :center_y, :baseline].freeze
      TARGET_ATTRIBUTE_DOMAIN = [:none, :left, :right, :top, :bottom, :start, :end, :width, :height, :center_x, :center_y, :baseline].freeze

      attr_reader :constant, :multiplier, :relation, :source, :source_attribute, :strength, :target, :target_attribute
    end
  end

  module Gtk
    class ConstraintGuide < GtkAst::GObject::Object
      include ConstraintTarget

      TYPE = "Gtk.ConstraintGuide"
      GTYPE = "GtkConstraintGuide"
      FIELDS = [:max_height, :max_width, :min_height, :min_width, :name, :nat_height, :nat_width, :strength].freeze
      PROPERTIES = {max_height: "max-height", max_width: "max-width", min_height: "min-height", min_width: "min-width", name: "name", nat_height: "nat-height", nat_width: "nat-width", strength: "strength"}.freeze
      KEYS = (superclass::KEYS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      STRENGTH_DOMAIN = [:required, :strong, :medium, :weak].freeze

      attr_reader :max_height, :max_width, :min_height, :min_width, :name, :nat_height, :nat_width, :strength
    end
  end

  module Gtk
    class ConstraintLayout < LayoutManager
      include Buildable

      TYPE = "Gtk.ConstraintLayout"
      GTYPE = "GtkConstraintLayout"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Buildable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class LayoutChild < GtkAst::GObject::Object

      TYPE = "Gtk.LayoutChild"
      GTYPE = "GtkLayoutChild"
      FIELDS = [:child_widget, :layout_manager].freeze
      PROPERTIES = {child_widget: "child-widget", layout_manager: "layout-manager"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :child_widget, :layout_manager
    end
  end

  module Gtk
    class ConstraintLayoutChild < LayoutChild

      TYPE = "Gtk.ConstraintLayoutChild"
      GTYPE = "GtkConstraintLayoutChild"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class CssProvider < GtkAst::GObject::Object
      include StyleProvider

      TYPE = "Gtk.CssProvider"
      GTYPE = "GtkCssProvider"
      FIELDS = [:prefers_color_scheme, :prefers_contrast, :prefers_reduced_motion].freeze
      PROPERTIES = {prefers_color_scheme: "prefers-color-scheme", prefers_contrast: "prefers-contrast", prefers_reduced_motion: "prefers-reduced-motion"}.freeze
      KEYS = (superclass::KEYS + StyleProvider::FIELDS + FIELDS).uniq.freeze
      PREFERS_COLOR_SCHEME_DOMAIN = [:unsupported, :default, :dark, :light].freeze
      PREFERS_CONTRAST_DOMAIN = [:unsupported, :no_preference, :more, :less].freeze
      PREFERS_REDUCED_MOTION_DOMAIN = [:no_preference, :reduce].freeze

      attr_reader :prefers_color_scheme, :prefers_contrast, :prefers_reduced_motion
    end
  end

  module Gtk
    class CustomFilter < Filter

      TYPE = "Gtk.CustomFilter"
      GTYPE = "GtkCustomFilter"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class CustomLayout < LayoutManager

      TYPE = "Gtk.CustomLayout"
      GTYPE = "GtkCustomLayout"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class CustomSorter < Sorter

      TYPE = "Gtk.CustomSorter"
      GTYPE = "GtkCustomSorter"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class DirectoryList < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel

      TYPE = "Gtk.DirectoryList"
      GTYPE = "GtkDirectoryList"
      FIELDS = [:attributes, :error, :file, :io_priority, :item_type, :loading, :monitored, :n_items].freeze
      PROPERTIES = {attributes: "attributes", error: "error", file: "file", io_priority: "io-priority", item_type: "item-type", loading: "loading", monitored: "monitored", n_items: "n-items"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :attributes, :error, :file, :io_priority, :item_type, :loading, :monitored, :n_items
    end
  end

  module Gtk
    class DragIcon < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Native
      include Root

      TYPE = "Gtk.DragIcon"
      GTYPE = "GtkDragIcon"
      FIELDS = [:child].freeze
      PROPERTIES = {child: "child"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + Root::FIELDS + FIELDS).uniq.freeze

      attr_reader :child
    end
  end

  module Gtk
    class EventController < GtkAst::GObject::Object

      TYPE = "Gtk.EventController"
      GTYPE = "GtkEventController"
      FIELDS = [:name, :propagation_limit, :propagation_phase, :widget].freeze
      PROPERTIES = {name: "name", propagation_limit: "propagation-limit", propagation_phase: "propagation-phase", widget: "widget"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      PROPAGATION_LIMIT_DOMAIN = [:none, :same_native].freeze
      PROPAGATION_PHASE_DOMAIN = [:none, :capture, :bubble, :target].freeze

      attr_reader :name, :propagation_limit, :propagation_phase, :widget
    end
  end

  module Gtk
    class Gesture < EventController

      TYPE = "Gtk.Gesture"
      GTYPE = "GtkGesture"
      FIELDS = [:n_points].freeze
      PROPERTIES = {n_points: "n-points"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :n_points
    end
  end

  module Gtk
    class GestureSingle < Gesture

      TYPE = "Gtk.GestureSingle"
      GTYPE = "GtkGestureSingle"
      FIELDS = [:button, :exclusive, :touch_only].freeze
      PROPERTIES = {button: "button", exclusive: "exclusive", touch_only: "touch-only"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :button, :exclusive, :touch_only
    end
  end

  module Gtk
    class DragSource < GestureSingle

      TYPE = "Gtk.DragSource"
      GTYPE = "GtkDragSource"
      FIELDS = [:actions, :content].freeze
      PROPERTIES = {actions: "actions", content: "content"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      ACTIONS_DOMAIN = [:none, :copy, :move, :link, :ask].freeze

      attr_reader :actions, :content
    end
  end

  module Gtk
    class DrawingArea < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.DrawingArea"
      GTYPE = "GtkDrawingArea"
      FIELDS = [:content_height, :content_width].freeze
      PROPERTIES = {content_height: "content-height", content_width: "content-width"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :content_height, :content_width
    end
  end

  module Gtk
    class DropControllerMotion < EventController

      TYPE = "Gtk.DropControllerMotion"
      GTYPE = "GtkDropControllerMotion"
      FIELDS = [:contains_pointer, :drop, :is_pointer].freeze
      PROPERTIES = {contains_pointer: "contains-pointer", drop: "drop", is_pointer: "is-pointer"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :contains_pointer, :drop, :is_pointer
    end
  end

  module Gtk
    class DropDown < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.DropDown"
      GTYPE = "GtkDropDown"
      FIELDS = [:enable_search, :expression, :factory, :header_factory, :list_factory, :model, :search_match_mode, :selected, :selected_item, :show_arrow].freeze
      PROPERTIES = {enable_search: "enable-search", expression: "expression", factory: "factory", header_factory: "header-factory", list_factory: "list-factory", model: "model", search_match_mode: "search-match-mode", selected: "selected", selected_item: "selected-item", show_arrow: "show-arrow"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      SEARCH_MATCH_MODE_DOMAIN = [:exact, :substring, :prefix].freeze

      attr_reader :enable_search, :expression, :factory, :header_factory, :list_factory, :model, :search_match_mode, :selected, :selected_item, :show_arrow
    end
  end

  module Gtk
    class DropTarget < EventController

      TYPE = "Gtk.DropTarget"
      GTYPE = "GtkDropTarget"
      FIELDS = [:actions, :current_drop, :drop, :formats, :preload, :value].freeze
      PROPERTIES = {actions: "actions", current_drop: "current-drop", drop: "drop", formats: "formats", preload: "preload", value: "value"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      ACTIONS_DOMAIN = [:none, :copy, :move, :link, :ask].freeze

      attr_reader :actions, :current_drop, :drop, :formats, :preload, :value
    end
  end

  module Gtk
    class DropTargetAsync < EventController

      TYPE = "Gtk.DropTargetAsync"
      GTYPE = "GtkDropTargetAsync"
      FIELDS = [:actions, :formats].freeze
      PROPERTIES = {actions: "actions", formats: "formats"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      ACTIONS_DOMAIN = [:none, :copy, :move, :link, :ask].freeze

      attr_reader :actions, :formats
    end
  end

  module Gtk
    class EditableLabel < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Editable

      TYPE = "Gtk.EditableLabel"
      GTYPE = "GtkEditableLabel"
      FIELDS = [:editing].freeze
      PROPERTIES = {editing: "editing"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Editable::FIELDS + FIELDS).uniq.freeze

      attr_reader :editing
    end
  end

  module Gtk
    class Popover < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Native
      include ShortcutManager

      TYPE = "Gtk.Popover"
      GTYPE = "GtkPopover"
      FIELDS = [:autohide, :cascade_popdown, :child, :default_widget, :has_arrow, :mnemonics_visible, :pointing_to, :position].freeze
      PROPERTIES = {autohide: "autohide", cascade_popdown: "cascade-popdown", child: "child", default_widget: "default-widget", has_arrow: "has-arrow", mnemonics_visible: "mnemonics-visible", pointing_to: "pointing-to", position: "position"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze
      POSITION_DOMAIN = [:left, :right, :top, :bottom].freeze

      attr_reader :autohide, :cascade_popdown, :child, :default_widget, :has_arrow, :mnemonics_visible, :pointing_to, :position
    end
  end

  module Gtk
    class EmojiChooser < Popover
      include Accessible
      include Buildable
      include ConstraintTarget
      include Native
      include ShortcutManager

      TYPE = "Gtk.EmojiChooser"
      GTYPE = "GtkEmojiChooser"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class Entry < Widget
      include Accessible
      include Buildable
      include CellEditable
      include ConstraintTarget
      include Editable

      TYPE = "Gtk.Entry"
      GTYPE = "GtkEntry"
      FIELDS = [:activates_default, :attributes, :buffer, :completion, :enable_emoji_completion, :extra_menu, :has_frame, :im_module, :input_hints, :input_purpose, :invisible_char, :invisible_char_set, :max_length, :menu_entry_icon_primary_text, :menu_entry_icon_secondary_text, :overwrite_mode, :placeholder_text, :primary_icon_activatable, :primary_icon_gicon, :primary_icon_name, :primary_icon_paintable, :primary_icon_sensitive, :primary_icon_storage_type, :primary_icon_tooltip_markup, :primary_icon_tooltip_text, :progress_fraction, :progress_pulse_step, :scroll_offset, :secondary_icon_activatable, :secondary_icon_gicon, :secondary_icon_name, :secondary_icon_paintable, :secondary_icon_sensitive, :secondary_icon_storage_type, :secondary_icon_tooltip_markup, :secondary_icon_tooltip_text, :show_emoji_icon, :tabs, :text_length, :truncate_multiline, :visibility].freeze
      PROPERTIES = {activates_default: "activates-default", attributes: "attributes", buffer: "buffer", completion: "completion", enable_emoji_completion: "enable-emoji-completion", extra_menu: "extra-menu", has_frame: "has-frame", im_module: "im-module", input_hints: "input-hints", input_purpose: "input-purpose", invisible_char: "invisible-char", invisible_char_set: "invisible-char-set", max_length: "max-length", menu_entry_icon_primary_text: "menu-entry-icon-primary-text", menu_entry_icon_secondary_text: "menu-entry-icon-secondary-text", overwrite_mode: "overwrite-mode", placeholder_text: "placeholder-text", primary_icon_activatable: "primary-icon-activatable", primary_icon_gicon: "primary-icon-gicon", primary_icon_name: "primary-icon-name", primary_icon_paintable: "primary-icon-paintable", primary_icon_sensitive: "primary-icon-sensitive", primary_icon_storage_type: "primary-icon-storage-type", primary_icon_tooltip_markup: "primary-icon-tooltip-markup", primary_icon_tooltip_text: "primary-icon-tooltip-text", progress_fraction: "progress-fraction", progress_pulse_step: "progress-pulse-step", scroll_offset: "scroll-offset", secondary_icon_activatable: "secondary-icon-activatable", secondary_icon_gicon: "secondary-icon-gicon", secondary_icon_name: "secondary-icon-name", secondary_icon_paintable: "secondary-icon-paintable", secondary_icon_sensitive: "secondary-icon-sensitive", secondary_icon_storage_type: "secondary-icon-storage-type", secondary_icon_tooltip_markup: "secondary-icon-tooltip-markup", secondary_icon_tooltip_text: "secondary-icon-tooltip-text", show_emoji_icon: "show-emoji-icon", tabs: "tabs", text_length: "text-length", truncate_multiline: "truncate-multiline", visibility: "visibility"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + CellEditable::FIELDS + ConstraintTarget::FIELDS + Editable::FIELDS + FIELDS).uniq.freeze
      INPUT_HINTS_DOMAIN = [:none, :spellcheck, :no_spellcheck, :word_completion, :lowercase, :uppercase_chars, :uppercase_words, :uppercase_sentences, :inhibit_osk, :vertical_writing, :emoji, :no_emoji, :private].freeze
      INPUT_PURPOSE_DOMAIN = [:free_form, :alpha, :digits, :number, :phone, :url, :email, :name, :password, :pin, :terminal].freeze
      PRIMARY_ICON_STORAGE_TYPE_DOMAIN = [:empty, :icon_name, :gicon, :paintable].freeze
      SECONDARY_ICON_STORAGE_TYPE_DOMAIN = [:empty, :icon_name, :gicon, :paintable].freeze

      attr_reader :activates_default, :attributes, :buffer, :completion, :enable_emoji_completion, :extra_menu, :has_frame, :im_module, :input_hints, :input_purpose, :invisible_char, :invisible_char_set, :max_length, :menu_entry_icon_primary_text, :menu_entry_icon_secondary_text, :overwrite_mode, :placeholder_text, :primary_icon_activatable, :primary_icon_gicon, :primary_icon_name, :primary_icon_paintable, :primary_icon_sensitive, :primary_icon_storage_type, :primary_icon_tooltip_markup, :primary_icon_tooltip_text, :progress_fraction, :progress_pulse_step, :scroll_offset, :secondary_icon_activatable, :secondary_icon_gicon, :secondary_icon_name, :secondary_icon_paintable, :secondary_icon_sensitive, :secondary_icon_storage_type, :secondary_icon_tooltip_markup, :secondary_icon_tooltip_text, :show_emoji_icon, :tabs, :text_length, :truncate_multiline, :visibility
    end
  end

  module Gtk
    class EntryBuffer < GtkAst::GObject::Object

      TYPE = "Gtk.EntryBuffer"
      GTYPE = "GtkEntryBuffer"
      FIELDS = [:length, :max_length, :text].freeze
      PROPERTIES = {length: "length", max_length: "max-length", text: "text"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :length, :max_length, :text
    end
  end

  module Gtk
    class EntryCompletion < GtkAst::GObject::Object
      include Buildable
      include CellLayout

      TYPE = "Gtk.EntryCompletion"
      GTYPE = "GtkEntryCompletion"
      FIELDS = [:cell_area, :inline_completion, :inline_selection, :minimum_key_length, :model, :popup_completion, :popup_set_width, :popup_single_match, :text_column].freeze
      PROPERTIES = {cell_area: "cell-area", inline_completion: "inline-completion", inline_selection: "inline-selection", minimum_key_length: "minimum-key-length", model: "model", popup_completion: "popup-completion", popup_set_width: "popup-set-width", popup_single_match: "popup-single-match", text_column: "text-column"}.freeze
      KEYS = (superclass::KEYS + Buildable::FIELDS + CellLayout::FIELDS + FIELDS).uniq.freeze

      attr_reader :cell_area, :inline_completion, :inline_selection, :minimum_key_length, :model, :popup_completion, :popup_set_width, :popup_single_match, :text_column
    end
  end

  module Gtk
    class EventControllerFocus < EventController

      TYPE = "Gtk.EventControllerFocus"
      GTYPE = "GtkEventControllerFocus"
      FIELDS = [:contains_focus, :is_focus].freeze
      PROPERTIES = {contains_focus: "contains-focus", is_focus: "is-focus"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :contains_focus, :is_focus
    end
  end

  module Gtk
    class EventControllerKey < EventController

      TYPE = "Gtk.EventControllerKey"
      GTYPE = "GtkEventControllerKey"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class EventControllerLegacy < EventController

      TYPE = "Gtk.EventControllerLegacy"
      GTYPE = "GtkEventControllerLegacy"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class EventControllerMotion < EventController

      TYPE = "Gtk.EventControllerMotion"
      GTYPE = "GtkEventControllerMotion"
      FIELDS = [:contains_pointer, :is_pointer].freeze
      PROPERTIES = {contains_pointer: "contains-pointer", is_pointer: "is-pointer"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :contains_pointer, :is_pointer
    end
  end

  module Gtk
    class EventControllerScroll < EventController

      TYPE = "Gtk.EventControllerScroll"
      GTYPE = "GtkEventControllerScroll"
      FIELDS = [:flags].freeze
      PROPERTIES = {flags: "flags"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      FLAGS_DOMAIN = [:none, :vertical, :horizontal, :discrete, :kinetic, :physical_direction, :both_axes].freeze

      attr_reader :flags
    end
  end

  module Gtk
    class EveryFilter < MultiFilter
      include GtkAst::Gio::ListModel
      include Buildable

      TYPE = "Gtk.EveryFilter"
      GTYPE = "GtkEveryFilter"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + Buildable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class Expander < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Expander"
      GTYPE = "GtkExpander"
      FIELDS = [:child, :expanded, :label, :label_widget, :resize_toplevel, :use_markup, :use_underline].freeze
      PROPERTIES = {child: "child", expanded: "expanded", label: "label", label_widget: "label-widget", resize_toplevel: "resize-toplevel", use_markup: "use-markup", use_underline: "use-underline"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :child, :expanded, :label, :label_widget, :resize_toplevel, :use_markup, :use_underline
    end
  end

  module Gtk
    class FileChooserDialog < Dialog
      include Accessible
      include Buildable
      include ConstraintTarget
      include FileChooser
      include Native
      include Root
      include ShortcutManager

      TYPE = "Gtk.FileChooserDialog"
      GTYPE = "GtkFileChooserDialog"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FileChooser::FIELDS + Native::FIELDS + Root::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class NativeDialog < GtkAst::GObject::Object

      TYPE = "Gtk.NativeDialog"
      GTYPE = "GtkNativeDialog"
      FIELDS = [:modal, :title, :transient_for, :visible].freeze
      PROPERTIES = {modal: "modal", title: "title", transient_for: "transient-for", visible: "visible"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :modal, :title, :transient_for, :visible
    end
  end

  module Gtk
    class FileChooserNative < NativeDialog
      include FileChooser

      TYPE = "Gtk.FileChooserNative"
      GTYPE = "GtkFileChooserNative"
      FIELDS = [:accept_label, :cancel_label].freeze
      PROPERTIES = {accept_label: "accept-label", cancel_label: "cancel-label"}.freeze
      KEYS = (superclass::KEYS + FileChooser::FIELDS + FIELDS).uniq.freeze

      attr_reader :accept_label, :cancel_label
    end
  end

  module Gtk
    class FileChooserWidget < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include FileChooser

      TYPE = "Gtk.FileChooserWidget"
      GTYPE = "GtkFileChooserWidget"
      FIELDS = [:search_mode, :show_time, :subtitle].freeze
      PROPERTIES = {search_mode: "search-mode", show_time: "show-time", subtitle: "subtitle"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FileChooser::FIELDS + FIELDS).uniq.freeze

      attr_reader :search_mode, :show_time, :subtitle
    end
  end

  module Gtk
    class FileDialog < GtkAst::GObject::Object

      TYPE = "Gtk.FileDialog"
      GTYPE = "GtkFileDialog"
      FIELDS = [:accept_label, :default_filter, :filters, :initial_file, :initial_folder, :initial_name, :modal, :title].freeze
      PROPERTIES = {accept_label: "accept-label", default_filter: "default-filter", filters: "filters", initial_file: "initial-file", initial_folder: "initial-folder", initial_name: "initial-name", modal: "modal", title: "title"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :accept_label, :default_filter, :filters, :initial_file, :initial_folder, :initial_name, :modal, :title
    end
  end

  module Gtk
    class FileFilter < Filter
      include Buildable

      TYPE = "Gtk.FileFilter"
      GTYPE = "GtkFileFilter"
      FIELDS = [:mime_types, :name, :patterns, :suffixes].freeze
      PROPERTIES = {mime_types: "mime-types", name: "name", patterns: "patterns", suffixes: "suffixes"}.freeze
      KEYS = (superclass::KEYS + Buildable::FIELDS + FIELDS).uniq.freeze

      attr_reader :mime_types, :name, :patterns, :suffixes
    end
  end

  module Gtk
    class FileLauncher < GtkAst::GObject::Object

      TYPE = "Gtk.FileLauncher"
      GTYPE = "GtkFileLauncher"
      FIELDS = [:always_ask, :file, :writable].freeze
      PROPERTIES = {always_ask: "always-ask", file: "file", writable: "writable"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :always_ask, :file, :writable
    end
  end

  module Gtk
    class FilterListModel < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel
      include SectionModel

      TYPE = "Gtk.FilterListModel"
      GTYPE = "GtkFilterListModel"
      FIELDS = [:filter, :incremental, :item_type, :model, :n_items, :pending, :watch_items].freeze
      PROPERTIES = {filter: "filter", incremental: "incremental", item_type: "item-type", model: "model", n_items: "n-items", pending: "pending", watch_items: "watch-items"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + SectionModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :filter, :incremental, :item_type, :model, :n_items, :pending, :watch_items
    end
  end

  module Gtk
    class Fixed < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Fixed"
      GTYPE = "GtkFixed"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class FixedLayout < LayoutManager

      TYPE = "Gtk.FixedLayout"
      GTYPE = "GtkFixedLayout"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class FixedLayoutChild < LayoutChild

      TYPE = "Gtk.FixedLayoutChild"
      GTYPE = "GtkFixedLayoutChild"
      FIELDS = [:transform].freeze
      PROPERTIES = {transform: "transform"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :transform
    end
  end

  module Gtk
    class FlattenListModel < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel
      include SectionModel

      TYPE = "Gtk.FlattenListModel"
      GTYPE = "GtkFlattenListModel"
      FIELDS = [:item_type, :model, :n_items].freeze
      PROPERTIES = {item_type: "item-type", model: "model", n_items: "n-items"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + SectionModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :item_type, :model, :n_items
    end
  end

  module Gtk
    class FlowBox < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.FlowBox"
      GTYPE = "GtkFlowBox"
      FIELDS = [:accept_unpaired_release, :activate_on_single_click, :column_spacing, :homogeneous, :max_children_per_line, :min_children_per_line, :row_spacing, :selection_mode].freeze
      PROPERTIES = {accept_unpaired_release: "accept-unpaired-release", activate_on_single_click: "activate-on-single-click", column_spacing: "column-spacing", homogeneous: "homogeneous", max_children_per_line: "max-children-per-line", min_children_per_line: "min-children-per-line", row_spacing: "row-spacing", selection_mode: "selection-mode"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze
      SELECTION_MODE_DOMAIN = [:none, :single, :browse, :multiple].freeze

      attr_reader :accept_unpaired_release, :activate_on_single_click, :column_spacing, :homogeneous, :max_children_per_line, :min_children_per_line, :row_spacing, :selection_mode
    end
  end

  module Gtk
    class FlowBoxChild < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.FlowBoxChild"
      GTYPE = "GtkFlowBoxChild"
      FIELDS = [:child].freeze
      PROPERTIES = {child: "child"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :child
    end
  end

  module Gtk
    class FontButton < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include FontChooser

      TYPE = "Gtk.FontButton"
      GTYPE = "GtkFontButton"
      FIELDS = [:modal, :title, :use_font, :use_size].freeze
      PROPERTIES = {modal: "modal", title: "title", use_font: "use-font", use_size: "use-size"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FontChooser::FIELDS + FIELDS).uniq.freeze

      attr_reader :modal, :title, :use_font, :use_size
    end
  end

  module Gtk
    class FontChooserDialog < Dialog
      include Accessible
      include Buildable
      include ConstraintTarget
      include FontChooser
      include Native
      include Root
      include ShortcutManager

      TYPE = "Gtk.FontChooserDialog"
      GTYPE = "GtkFontChooserDialog"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FontChooser::FIELDS + Native::FIELDS + Root::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class FontChooserWidget < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include FontChooser

      TYPE = "Gtk.FontChooserWidget"
      GTYPE = "GtkFontChooserWidget"
      FIELDS = [:tweak_action].freeze
      PROPERTIES = {tweak_action: "tweak-action"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FontChooser::FIELDS + FIELDS).uniq.freeze

      attr_reader :tweak_action
    end
  end

  module Gtk
    class FontDialog < GtkAst::GObject::Object

      TYPE = "Gtk.FontDialog"
      GTYPE = "GtkFontDialog"
      FIELDS = [:filter, :font_map, :language, :modal, :title].freeze
      PROPERTIES = {filter: "filter", font_map: "font-map", language: "language", modal: "modal", title: "title"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :filter, :font_map, :language, :modal, :title
    end
  end

  module Gtk
    class FontDialogButton < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.FontDialogButton"
      GTYPE = "GtkFontDialogButton"
      FIELDS = [:dialog, :font_desc, :font_features, :language, :level, :use_font, :use_size].freeze
      PROPERTIES = {dialog: "dialog", font_desc: "font-desc", font_features: "font-features", language: "language", level: "level", use_font: "use-font", use_size: "use-size"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      LEVEL_DOMAIN = [:family, :face, :font, :features].freeze

      attr_reader :dialog, :font_desc, :font_features, :language, :level, :use_font, :use_size
    end
  end

  module Gtk
    class Frame < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Frame"
      GTYPE = "GtkFrame"
      FIELDS = [:child, :label, :label_widget, :label_xalign].freeze
      PROPERTIES = {child: "child", label: "label", label_widget: "label-widget", label_xalign: "label-xalign"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :child, :label, :label_widget, :label_xalign
    end
  end

  module Gtk
    class GLArea < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.GLArea"
      GTYPE = "GtkGLArea"
      FIELDS = [:allowed_apis, :api, :auto_render, :context, :has_depth_buffer, :has_stencil_buffer, :use_es].freeze
      PROPERTIES = {allowed_apis: "allowed-apis", api: "api", auto_render: "auto-render", context: "context", has_depth_buffer: "has-depth-buffer", has_stencil_buffer: "has-stencil-buffer", use_es: "use-es"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      ALLOWED_APIS_DOMAIN = [:gl, :gles].freeze
      API_DOMAIN = [:gl, :gles].freeze

      attr_reader :allowed_apis, :api, :auto_render, :context, :has_depth_buffer, :has_stencil_buffer, :use_es
    end
  end

  module Gtk
    class GestureClick < GestureSingle

      TYPE = "Gtk.GestureClick"
      GTYPE = "GtkGestureClick"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class GestureDrag < GestureSingle

      TYPE = "Gtk.GestureDrag"
      GTYPE = "GtkGestureDrag"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class GestureLongPress < GestureSingle

      TYPE = "Gtk.GestureLongPress"
      GTYPE = "GtkGestureLongPress"
      FIELDS = [:delay_factor].freeze
      PROPERTIES = {delay_factor: "delay-factor"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :delay_factor
    end
  end

  module Gtk
    class GesturePan < GestureDrag

      TYPE = "Gtk.GesturePan"
      GTYPE = "GtkGesturePan"
      FIELDS = [:orientation].freeze
      PROPERTIES = {orientation: "orientation"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      ORIENTATION_DOMAIN = [:horizontal, :vertical].freeze

      attr_reader :orientation
    end
  end

  module Gtk
    class GestureRotate < Gesture

      TYPE = "Gtk.GestureRotate"
      GTYPE = "GtkGestureRotate"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class GestureStylus < GestureSingle

      TYPE = "Gtk.GestureStylus"
      GTYPE = "GtkGestureStylus"
      FIELDS = [:stylus_only].freeze
      PROPERTIES = {stylus_only: "stylus-only"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :stylus_only
    end
  end

  module Gtk
    class GestureSwipe < GestureSingle

      TYPE = "Gtk.GestureSwipe"
      GTYPE = "GtkGestureSwipe"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class GestureZoom < Gesture

      TYPE = "Gtk.GestureZoom"
      GTYPE = "GtkGestureZoom"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class GraphicsOffload < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.GraphicsOffload"
      GTYPE = "GtkGraphicsOffload"
      FIELDS = [:black_background, :child, :enabled].freeze
      PROPERTIES = {black_background: "black-background", child: "child", enabled: "enabled"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      ENABLED_DOMAIN = [:enabled, :disabled].freeze

      attr_reader :black_background, :child, :enabled
    end
  end

  module Gtk
    class Grid < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.Grid"
      GTYPE = "GtkGrid"
      FIELDS = [:baseline_row, :column_homogeneous, :column_spacing, :row_homogeneous, :row_spacing].freeze
      PROPERTIES = {baseline_row: "baseline-row", column_homogeneous: "column-homogeneous", column_spacing: "column-spacing", row_homogeneous: "row-homogeneous", row_spacing: "row-spacing"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :baseline_row, :column_homogeneous, :column_spacing, :row_homogeneous, :row_spacing
    end
  end

  module Gtk
    class GridLayout < LayoutManager

      TYPE = "Gtk.GridLayout"
      GTYPE = "GtkGridLayout"
      FIELDS = [:baseline_row, :column_homogeneous, :column_spacing, :row_homogeneous, :row_spacing].freeze
      PROPERTIES = {baseline_row: "baseline-row", column_homogeneous: "column-homogeneous", column_spacing: "column-spacing", row_homogeneous: "row-homogeneous", row_spacing: "row-spacing"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :baseline_row, :column_homogeneous, :column_spacing, :row_homogeneous, :row_spacing
    end
  end

  module Gtk
    class GridLayoutChild < LayoutChild

      TYPE = "Gtk.GridLayoutChild"
      GTYPE = "GtkGridLayoutChild"
      FIELDS = [:column, :column_span, :row, :row_span].freeze
      PROPERTIES = {column: "column", column_span: "column-span", row: "row", row_span: "row-span"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :column, :column_span, :row, :row_span
    end
  end

  module Gtk
    class ListBase < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Orientable
      include Scrollable

      TYPE = "Gtk.ListBase"
      GTYPE = "GtkListBase"
      FIELDS = [:orientation].freeze
      PROPERTIES = {orientation: "orientation"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + Scrollable::FIELDS + FIELDS).uniq.freeze
      ORIENTATION_DOMAIN = [:horizontal, :vertical].freeze

      attr_reader :orientation
    end
  end

  module Gtk
    class GridView < ListBase
      include Accessible
      include Buildable
      include ConstraintTarget
      include Orientable
      include Scrollable

      TYPE = "Gtk.GridView"
      GTYPE = "GtkGridView"
      FIELDS = [:enable_rubberband, :factory, :max_columns, :min_columns, :model, :single_click_activate, :tab_behavior].freeze
      PROPERTIES = {enable_rubberband: "enable-rubberband", factory: "factory", max_columns: "max-columns", min_columns: "min-columns", model: "model", single_click_activate: "single-click-activate", tab_behavior: "tab-behavior"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + Scrollable::FIELDS + FIELDS).uniq.freeze
      TAB_BEHAVIOR_DOMAIN = [:all, :item, :cell].freeze

      attr_reader :enable_rubberband, :factory, :max_columns, :min_columns, :model, :single_click_activate, :tab_behavior
    end
  end

  module Gtk
    class HeaderBar < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.HeaderBar"
      GTYPE = "GtkHeaderBar"
      FIELDS = [:decoration_layout, :show_title_buttons, :title_widget, :use_native_controls].freeze
      PROPERTIES = {decoration_layout: "decoration-layout", show_title_buttons: "show-title-buttons", title_widget: "title-widget", use_native_controls: "use-native-controls"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :decoration_layout, :show_title_buttons, :title_widget, :use_native_controls
    end
  end

  module Gtk
    class IMContext < GtkAst::GObject::Object

      TYPE = "Gtk.IMContext"
      GTYPE = "GtkIMContext"
      FIELDS = [:input_hints, :input_purpose].freeze
      PROPERTIES = {input_hints: "input-hints", input_purpose: "input-purpose"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      INPUT_HINTS_DOMAIN = [:none, :spellcheck, :no_spellcheck, :word_completion, :lowercase, :uppercase_chars, :uppercase_words, :uppercase_sentences, :inhibit_osk, :vertical_writing, :emoji, :no_emoji, :private].freeze
      INPUT_PURPOSE_DOMAIN = [:free_form, :alpha, :digits, :number, :phone, :url, :email, :name, :password, :pin, :terminal].freeze

      attr_reader :input_hints, :input_purpose
    end
  end

  module Gtk
    class IMContextSimple < IMContext

      TYPE = "Gtk.IMContextSimple"
      GTYPE = "GtkIMContextSimple"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class IMMulticontext < IMContext

      TYPE = "Gtk.IMMulticontext"
      GTYPE = "GtkIMMulticontext"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class IconPaintable < GtkAst::GObject::Object
      include GtkAst::Gdk::Paintable
      include SymbolicPaintable

      TYPE = "Gtk.IconPaintable"
      GTYPE = "GtkIconPaintable"
      FIELDS = [:file, :icon_name, :is_symbolic, :scale, :size].freeze
      PROPERTIES = {file: "file", icon_name: "icon-name", is_symbolic: "is-symbolic", scale: "scale", size: "size"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gdk::Paintable::FIELDS + SymbolicPaintable::FIELDS + FIELDS).uniq.freeze

      attr_reader :file, :icon_name, :is_symbolic, :scale, :size
    end
  end

  module Gtk
    class IconTheme < GtkAst::GObject::Object

      TYPE = "Gtk.IconTheme"
      GTYPE = "GtkIconTheme"
      FIELDS = [:display, :icon_names, :resource_path, :search_path, :theme_name].freeze
      PROPERTIES = {display: "display", icon_names: "icon-names", resource_path: "resource-path", search_path: "search-path", theme_name: "theme-name"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :display, :icon_names, :resource_path, :search_path, :theme_name
    end
  end

  module Gtk
    class IconView < Widget
      include Accessible
      include Buildable
      include CellLayout
      include ConstraintTarget
      include Scrollable

      TYPE = "Gtk.IconView"
      GTYPE = "GtkIconView"
      FIELDS = [:activate_on_single_click, :cell_area, :column_spacing, :columns, :item_orientation, :item_padding, :item_width, :margin, :markup_column, :model, :pixbuf_column, :reorderable, :row_spacing, :selection_mode, :spacing, :text_column, :tooltip_column].freeze
      PROPERTIES = {activate_on_single_click: "activate-on-single-click", cell_area: "cell-area", column_spacing: "column-spacing", columns: "columns", item_orientation: "item-orientation", item_padding: "item-padding", item_width: "item-width", margin: "margin", markup_column: "markup-column", model: "model", pixbuf_column: "pixbuf-column", reorderable: "reorderable", row_spacing: "row-spacing", selection_mode: "selection-mode", spacing: "spacing", text_column: "text-column", tooltip_column: "tooltip-column"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + CellLayout::FIELDS + ConstraintTarget::FIELDS + Scrollable::FIELDS + FIELDS).uniq.freeze
      ITEM_ORIENTATION_DOMAIN = [:horizontal, :vertical].freeze
      SELECTION_MODE_DOMAIN = [:none, :single, :browse, :multiple].freeze

      attr_reader :activate_on_single_click, :cell_area, :column_spacing, :columns, :item_orientation, :item_padding, :item_width, :margin, :markup_column, :model, :pixbuf_column, :reorderable, :row_spacing, :selection_mode, :spacing, :text_column, :tooltip_column
    end
  end

  module Gtk
    class Image < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Image"
      GTYPE = "GtkImage"
      FIELDS = [:file, :gicon, :icon_name, :icon_size, :paintable, :pixel_size, :resource, :storage_type, :use_fallback].freeze
      PROPERTIES = {file: "file", gicon: "gicon", icon_name: "icon-name", icon_size: "icon-size", paintable: "paintable", pixel_size: "pixel-size", resource: "resource", storage_type: "storage-type", use_fallback: "use-fallback"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      ICON_SIZE_DOMAIN = [:inherit, :normal, :large].freeze
      STORAGE_TYPE_DOMAIN = [:empty, :icon_name, :gicon, :paintable].freeze

      attr_reader :file, :gicon, :icon_name, :icon_size, :paintable, :pixel_size, :resource, :storage_type, :use_fallback
    end
  end

  module Gtk
    class InfoBar < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.InfoBar"
      GTYPE = "GtkInfoBar"
      FIELDS = [:message_type, :revealed, :show_close_button].freeze
      PROPERTIES = {message_type: "message-type", revealed: "revealed", show_close_button: "show-close-button"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      MESSAGE_TYPE_DOMAIN = [:info, :warning, :question, :error, :other].freeze

      attr_reader :message_type, :revealed, :show_close_button
    end
  end

  module Gtk
    class Inscription < Widget
      include Accessible
      include AccessibleText
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Inscription"
      GTYPE = "GtkInscription"
      FIELDS = [:attributes, :markup, :min_chars, :min_lines, :nat_chars, :nat_lines, :text, :text_overflow, :wrap_mode, :xalign, :yalign].freeze
      PROPERTIES = {attributes: "attributes", markup: "markup", min_chars: "min-chars", min_lines: "min-lines", nat_chars: "nat-chars", nat_lines: "nat-lines", text: "text", text_overflow: "text-overflow", wrap_mode: "wrap-mode", xalign: "xalign", yalign: "yalign"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AccessibleText::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      TEXT_OVERFLOW_DOMAIN = [:clip, :ellipsize_start, :ellipsize_middle, :ellipsize_end].freeze
      WRAP_MODE_DOMAIN = [:word, :char, :word_char, :none].freeze

      attr_reader :attributes, :markup, :min_chars, :min_lines, :nat_chars, :nat_lines, :text, :text_overflow, :wrap_mode, :xalign, :yalign
    end
  end

  module Gtk
    class KeyvalTrigger < ShortcutTrigger

      TYPE = "Gtk.KeyvalTrigger"
      GTYPE = "GtkKeyvalTrigger"
      FIELDS = [:keyval, :modifiers].freeze
      PROPERTIES = {keyval: "keyval", modifiers: "modifiers"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      MODIFIERS_DOMAIN = [:no_modifier_mask, :shift_mask, :lock_mask, :control_mask, :alt_mask, :button1_mask, :button2_mask, :button3_mask, :button4_mask, :button5_mask, :super_mask, :hyper_mask, :meta_mask].freeze

      attr_reader :keyval, :modifiers
    end
  end

  module Gtk
    class Label < Widget
      include Accessible
      include AccessibleHypertext
      include AccessibleText
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Label"
      GTYPE = "GtkLabel"
      FIELDS = [:attributes, :ellipsize, :extra_menu, :justify, :label, :lines, :max_width_chars, :mnemonic_keyval, :mnemonic_widget, :natural_wrap_mode, :selectable, :single_line_mode, :tabs, :use_markup, :use_underline, :width_chars, :wrap, :wrap_mode, :xalign, :yalign].freeze
      PROPERTIES = {attributes: "attributes", ellipsize: "ellipsize", extra_menu: "extra-menu", justify: "justify", label: "label", lines: "lines", max_width_chars: "max-width-chars", mnemonic_keyval: "mnemonic-keyval", mnemonic_widget: "mnemonic-widget", natural_wrap_mode: "natural-wrap-mode", selectable: "selectable", single_line_mode: "single-line-mode", tabs: "tabs", use_markup: "use-markup", use_underline: "use-underline", width_chars: "width-chars", wrap: "wrap", wrap_mode: "wrap-mode", xalign: "xalign", yalign: "yalign"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AccessibleHypertext::FIELDS + AccessibleText::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      ELLIPSIZE_DOMAIN = [:none, :start, :middle, :end].freeze
      JUSTIFY_DOMAIN = [:left, :right, :center, :fill].freeze
      NATURAL_WRAP_MODE_DOMAIN = [:inherit, :none, :word].freeze
      WRAP_MODE_DOMAIN = [:word, :char, :word_char, :none].freeze

      attr_reader :attributes, :ellipsize, :extra_menu, :justify, :label, :lines, :max_width_chars, :mnemonic_keyval, :mnemonic_widget, :natural_wrap_mode, :selectable, :single_line_mode, :tabs, :use_markup, :use_underline, :width_chars, :wrap, :wrap_mode, :xalign, :yalign
    end
  end

  module Gtk
    class LevelBar < Widget
      include Accessible
      include AccessibleRange
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.LevelBar"
      GTYPE = "GtkLevelBar"
      FIELDS = [:inverted, :max_value, :min_value, :mode, :value].freeze
      PROPERTIES = {inverted: "inverted", max_value: "max-value", min_value: "min-value", mode: "mode", value: "value"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AccessibleRange::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze
      MODE_DOMAIN = [:continuous, :discrete].freeze

      attr_reader :inverted, :max_value, :min_value, :mode, :value
    end
  end

  module Gtk
    class LinkButton < Button
      include Accessible
      include Actionable
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.LinkButton"
      GTYPE = "GtkLinkButton"
      FIELDS = [:uri, :visited].freeze
      PROPERTIES = {uri: "uri", visited: "visited"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Actionable::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :uri, :visited
    end
  end

  module Gtk
    class ListBox < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.ListBox"
      GTYPE = "GtkListBox"
      FIELDS = [:accept_unpaired_release, :activate_on_single_click, :selection_mode, :show_separators, :tab_behavior].freeze
      PROPERTIES = {accept_unpaired_release: "accept-unpaired-release", activate_on_single_click: "activate-on-single-click", selection_mode: "selection-mode", show_separators: "show-separators", tab_behavior: "tab-behavior"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      SELECTION_MODE_DOMAIN = [:none, :single, :browse, :multiple].freeze
      TAB_BEHAVIOR_DOMAIN = [:all, :item, :cell].freeze

      attr_reader :accept_unpaired_release, :activate_on_single_click, :selection_mode, :show_separators, :tab_behavior
    end
  end

  module Gtk
    class ListHeader < GtkAst::GObject::Object

      TYPE = "Gtk.ListHeader"
      GTYPE = "GtkListHeader"
      FIELDS = [:child, :end, :item, :n_items, :start].freeze
      PROPERTIES = {child: "child", end: "end", item: "item", n_items: "n-items", start: "start"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :child, :end, :item, :n_items, :start
    end
  end

  module Gtk
    class ListStore < GtkAst::GObject::Object
      include Buildable
      include TreeDragDest
      include TreeDragSource
      include TreeModel
      include TreeSortable

      TYPE = "Gtk.ListStore"
      GTYPE = "GtkListStore"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Buildable::FIELDS + TreeDragDest::FIELDS + TreeDragSource::FIELDS + TreeModel::FIELDS + TreeSortable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class ListView < ListBase
      include Accessible
      include Buildable
      include ConstraintTarget
      include Orientable
      include Scrollable

      TYPE = "Gtk.ListView"
      GTYPE = "GtkListView"
      FIELDS = [:enable_rubberband, :factory, :header_factory, :model, :show_separators, :single_click_activate, :tab_behavior].freeze
      PROPERTIES = {enable_rubberband: "enable-rubberband", factory: "factory", header_factory: "header-factory", model: "model", show_separators: "show-separators", single_click_activate: "single-click-activate", tab_behavior: "tab-behavior"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + Scrollable::FIELDS + FIELDS).uniq.freeze
      TAB_BEHAVIOR_DOMAIN = [:all, :item, :cell].freeze

      attr_reader :enable_rubberband, :factory, :header_factory, :model, :show_separators, :single_click_activate, :tab_behavior
    end
  end

  module Gtk
    class LockButton < Button
      include Accessible
      include Actionable
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.LockButton"
      GTYPE = "GtkLockButton"
      FIELDS = [:permission, :text_lock, :text_unlock, :tooltip_lock, :tooltip_not_authorized, :tooltip_unlock].freeze
      PROPERTIES = {permission: "permission", text_lock: "text-lock", text_unlock: "text-unlock", tooltip_lock: "tooltip-lock", tooltip_not_authorized: "tooltip-not-authorized", tooltip_unlock: "tooltip-unlock"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Actionable::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :permission, :text_lock, :text_unlock, :tooltip_lock, :tooltip_not_authorized, :tooltip_unlock
    end
  end

  module Gtk
    class MapListModel < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel
      include SectionModel

      TYPE = "Gtk.MapListModel"
      GTYPE = "GtkMapListModel"
      FIELDS = [:has_map, :item_type, :model, :n_items].freeze
      PROPERTIES = {has_map: "has-map", item_type: "item-type", model: "model", n_items: "n-items"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + SectionModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :has_map, :item_type, :model, :n_items
    end
  end

  module Gtk
    class MediaControls < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.MediaControls"
      GTYPE = "GtkMediaControls"
      FIELDS = [:media_stream].freeze
      PROPERTIES = {media_stream: "media-stream"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :media_stream
    end
  end

  module Gtk
    class MediaStream < GtkAst::GObject::Object
      include GtkAst::Gdk::Paintable

      TYPE = "Gtk.MediaStream"
      GTYPE = "GtkMediaStream"
      FIELDS = [:duration, :ended, :error, :has_audio, :has_video, :loop, :muted, :playing, :prepared, :seekable, :seeking, :timestamp, :volume].freeze
      PROPERTIES = {duration: "duration", ended: "ended", error: "error", has_audio: "has-audio", has_video: "has-video", loop: "loop", muted: "muted", playing: "playing", prepared: "prepared", seekable: "seekable", seeking: "seeking", timestamp: "timestamp", volume: "volume"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gdk::Paintable::FIELDS + FIELDS).uniq.freeze

      attr_reader :duration, :ended, :error, :has_audio, :has_video, :loop, :muted, :playing, :prepared, :seekable, :seeking, :timestamp, :volume
    end
  end

  module Gtk
    class MediaFile < MediaStream
      include GtkAst::Gdk::Paintable

      TYPE = "Gtk.MediaFile"
      GTYPE = "GtkMediaFile"
      FIELDS = [:file, :input_stream].freeze
      PROPERTIES = {file: "file", input_stream: "input-stream"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gdk::Paintable::FIELDS + FIELDS).uniq.freeze

      attr_reader :file, :input_stream
    end
  end

  module Gtk
    class MenuButton < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.MenuButton"
      GTYPE = "GtkMenuButton"
      FIELDS = [:active, :always_show_arrow, :can_shrink, :child, :direction, :has_frame, :icon_name, :label, :menu_model, :popover, :primary, :use_underline].freeze
      PROPERTIES = {active: "active", always_show_arrow: "always-show-arrow", can_shrink: "can-shrink", child: "child", direction: "direction", has_frame: "has-frame", icon_name: "icon-name", label: "label", menu_model: "menu-model", popover: "popover", primary: "primary", use_underline: "use-underline"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      DIRECTION_DOMAIN = [:up, :down, :left, :right, :none].freeze

      attr_reader :active, :always_show_arrow, :can_shrink, :child, :direction, :has_frame, :icon_name, :label, :menu_model, :popover, :primary, :use_underline
    end
  end

  module Gtk
    class MessageDialog < Dialog
      include Accessible
      include Buildable
      include ConstraintTarget
      include Native
      include Root
      include ShortcutManager

      TYPE = "Gtk.MessageDialog"
      GTYPE = "GtkMessageDialog"
      FIELDS = [:buttons, :message_area, :message_type, :secondary_text, :secondary_use_markup, :text, :use_markup].freeze
      PROPERTIES = {buttons: "buttons", message_area: "message-area", message_type: "message-type", secondary_text: "secondary-text", secondary_use_markup: "secondary-use-markup", text: "text", use_markup: "use-markup"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + Root::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze
      BUTTONS_DOMAIN = [:none, :ok, :close, :cancel, :yes_no, :ok_cancel].freeze
      MESSAGE_TYPE_DOMAIN = [:info, :warning, :question, :error, :other].freeze

      attr_reader :buttons, :message_area, :message_type, :secondary_text, :secondary_use_markup, :text, :use_markup
    end
  end

  module Gtk
    class MnemonicAction < ShortcutAction

      TYPE = "Gtk.MnemonicAction"
      GTYPE = "GtkMnemonicAction"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class MnemonicTrigger < ShortcutTrigger

      TYPE = "Gtk.MnemonicTrigger"
      GTYPE = "GtkMnemonicTrigger"
      FIELDS = [:keyval].freeze
      PROPERTIES = {keyval: "keyval"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :keyval
    end
  end

  module Gtk
    class MountOperation < GtkAst::Gio::MountOperation

      TYPE = "Gtk.MountOperation"
      GTYPE = "GtkMountOperation"
      FIELDS = [:display, :is_showing, :parent].freeze
      PROPERTIES = {display: "display", is_showing: "is-showing", parent: "parent"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :display, :is_showing, :parent
    end
  end

  module Gtk
    class MultiSelection < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel
      include SectionModel
      include SelectionModel

      TYPE = "Gtk.MultiSelection"
      GTYPE = "GtkMultiSelection"
      FIELDS = [:item_type, :model, :n_items].freeze
      PROPERTIES = {item_type: "item-type", model: "model", n_items: "n-items"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + SectionModel::FIELDS + SelectionModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :item_type, :model, :n_items
    end
  end

  module Gtk
    class MultiSorter < Sorter
      include GtkAst::Gio::ListModel
      include Buildable

      TYPE = "Gtk.MultiSorter"
      GTYPE = "GtkMultiSorter"
      FIELDS = [:item_type, :n_items].freeze
      PROPERTIES = {item_type: "item-type", n_items: "n-items"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + Buildable::FIELDS + FIELDS).uniq.freeze

      attr_reader :item_type, :n_items
    end
  end

  module Gtk
    class NamedAction < ShortcutAction

      TYPE = "Gtk.NamedAction"
      GTYPE = "GtkNamedAction"
      FIELDS = [:action_name].freeze
      PROPERTIES = {action_name: "action-name"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :action_name
    end
  end

  module Gtk
    class NeverTrigger < ShortcutTrigger

      TYPE = "Gtk.NeverTrigger"
      GTYPE = "GtkNeverTrigger"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class NoSelection < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel
      include SectionModel
      include SelectionModel

      TYPE = "Gtk.NoSelection"
      GTYPE = "GtkNoSelection"
      FIELDS = [:item_type, :model, :n_items].freeze
      PROPERTIES = {item_type: "item-type", model: "model", n_items: "n-items"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + SectionModel::FIELDS + SelectionModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :item_type, :model, :n_items
    end
  end

  module Gtk
    class Notebook < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Notebook"
      GTYPE = "GtkNotebook"
      FIELDS = [:enable_popup, :group_name, :page, :pages, :scrollable, :show_border, :show_tabs, :tab_pos].freeze
      PROPERTIES = {enable_popup: "enable-popup", group_name: "group-name", page: "page", pages: "pages", scrollable: "scrollable", show_border: "show-border", show_tabs: "show-tabs", tab_pos: "tab-pos"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      TAB_POS_DOMAIN = [:left, :right, :top, :bottom].freeze

      attr_reader :enable_popup, :group_name, :page, :pages, :scrollable, :show_border, :show_tabs, :tab_pos
    end
  end

  module Gtk
    class NotebookPage < GtkAst::GObject::Object

      TYPE = "Gtk.NotebookPage"
      GTYPE = "GtkNotebookPage"
      FIELDS = [:child, :detachable, :menu, :menu_label, :position, :reorderable, :tab, :tab_expand, :tab_fill, :tab_label].freeze
      PROPERTIES = {child: "child", detachable: "detachable", menu: "menu", menu_label: "menu-label", position: "position", reorderable: "reorderable", tab: "tab", tab_expand: "tab-expand", tab_fill: "tab-fill", tab_label: "tab-label"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :child, :detachable, :menu, :menu_label, :position, :reorderable, :tab, :tab_expand, :tab_fill, :tab_label
    end
  end

  module Gtk
    class NothingAction < ShortcutAction

      TYPE = "Gtk.NothingAction"
      GTYPE = "GtkNothingAction"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class NumericSorter < Sorter

      TYPE = "Gtk.NumericSorter"
      GTYPE = "GtkNumericSorter"
      FIELDS = [:expression, :sort_order].freeze
      PROPERTIES = {expression: "expression", sort_order: "sort-order"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      SORT_ORDER_DOMAIN = [:ascending, :descending].freeze

      attr_reader :expression, :sort_order
    end
  end

  module Gtk
    class ObjectExpression < Expression

      TYPE = "Gtk.ObjectExpression"
      GTYPE = "GtkObjectExpression"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class Overlay < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Overlay"
      GTYPE = "GtkOverlay"
      FIELDS = [:child].freeze
      PROPERTIES = {child: "child"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :child
    end
  end

  module Gtk
    class OverlayLayout < LayoutManager

      TYPE = "Gtk.OverlayLayout"
      GTYPE = "GtkOverlayLayout"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class OverlayLayoutChild < LayoutChild

      TYPE = "Gtk.OverlayLayoutChild"
      GTYPE = "GtkOverlayLayoutChild"
      FIELDS = [:clip_overlay, :measure].freeze
      PROPERTIES = {clip_overlay: "clip-overlay", measure: "measure"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :clip_overlay, :measure
    end
  end

  module Gtk
    class PadController < EventController

      TYPE = "Gtk.PadController"
      GTYPE = "GtkPadController"
      FIELDS = [:action_group, :pad].freeze
      PROPERTIES = {action_group: "action-group", pad: "pad"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :action_group, :pad
    end
  end

  module Gtk
    class PageSetup < GtkAst::GObject::Object

      TYPE = "Gtk.PageSetup"
      GTYPE = "GtkPageSetup"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class PageSetupUnixDialog < Dialog
      include Accessible
      include Buildable
      include ConstraintTarget
      include Native
      include Root
      include ShortcutManager

      TYPE = "Gtk.PageSetupUnixDialog"
      GTYPE = "GtkPageSetupUnixDialog"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + Root::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class Paned < Widget
      include Accessible
      include AccessibleRange
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.Paned"
      GTYPE = "GtkPaned"
      FIELDS = [:end_child, :max_position, :min_position, :position, :position_set, :resize_end_child, :resize_start_child, :shrink_end_child, :shrink_start_child, :start_child, :wide_handle].freeze
      PROPERTIES = {end_child: "end-child", max_position: "max-position", min_position: "min-position", position: "position", position_set: "position-set", resize_end_child: "resize-end-child", resize_start_child: "resize-start-child", shrink_end_child: "shrink-end-child", shrink_start_child: "shrink-start-child", start_child: "start-child", wide_handle: "wide-handle"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AccessibleRange::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :end_child, :max_position, :min_position, :position, :position_set, :resize_end_child, :resize_start_child, :shrink_end_child, :shrink_start_child, :start_child, :wide_handle
    end
  end

  module Gtk
    class ParamSpecExpression < GtkAst::GObject::ParamSpec

      TYPE = "Gtk.ParamSpecExpression"
      GTYPE = "GtkParamSpecExpression"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class PasswordEntry < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Editable

      TYPE = "Gtk.PasswordEntry"
      GTYPE = "GtkPasswordEntry"
      FIELDS = [:activates_default, :extra_menu, :placeholder_text, :show_peek_icon].freeze
      PROPERTIES = {activates_default: "activates-default", extra_menu: "extra-menu", placeholder_text: "placeholder-text", show_peek_icon: "show-peek-icon"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Editable::FIELDS + FIELDS).uniq.freeze

      attr_reader :activates_default, :extra_menu, :placeholder_text, :show_peek_icon
    end
  end

  module Gtk
    class PasswordEntryBuffer < EntryBuffer

      TYPE = "Gtk.PasswordEntryBuffer"
      GTYPE = "GtkPasswordEntryBuffer"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class Picture < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Picture"
      GTYPE = "GtkPicture"
      FIELDS = [:alternative_text, :can_shrink, :content_fit, :file, :isolate_contents, :keep_aspect_ratio, :paintable].freeze
      PROPERTIES = {alternative_text: "alternative-text", can_shrink: "can-shrink", content_fit: "content-fit", file: "file", isolate_contents: "isolate-contents", keep_aspect_ratio: "keep-aspect-ratio", paintable: "paintable"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      CONTENT_FIT_DOMAIN = [:fill, :contain, :cover, :scale_down].freeze

      attr_reader :alternative_text, :can_shrink, :content_fit, :file, :isolate_contents, :keep_aspect_ratio, :paintable
    end
  end

  module Gtk
    class PopoverBin < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.PopoverBin"
      GTYPE = "GtkPopoverBin"
      FIELDS = [:child, :handle_input, :menu_model, :popover].freeze
      PROPERTIES = {child: "child", handle_input: "handle-input", menu_model: "menu-model", popover: "popover"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :child, :handle_input, :menu_model, :popover
    end
  end

  module Gtk
    class PopoverMenu < Popover
      include Accessible
      include Buildable
      include ConstraintTarget
      include Native
      include ShortcutManager

      TYPE = "Gtk.PopoverMenu"
      GTYPE = "GtkPopoverMenu"
      FIELDS = [:flags, :menu_model, :visible_submenu].freeze
      PROPERTIES = {flags: "flags", menu_model: "menu-model", visible_submenu: "visible-submenu"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze
      FLAGS_DOMAIN = [:sliding, :nested].freeze

      attr_reader :flags, :menu_model, :visible_submenu
    end
  end

  module Gtk
    class PopoverMenuBar < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.PopoverMenuBar"
      GTYPE = "GtkPopoverMenuBar"
      FIELDS = [:menu_model].freeze
      PROPERTIES = {menu_model: "menu-model"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :menu_model
    end
  end

  module Gtk
    class PrintContext < GtkAst::GObject::Object

      TYPE = "Gtk.PrintContext"
      GTYPE = "GtkPrintContext"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class PrintDialog < GtkAst::GObject::Object

      TYPE = "Gtk.PrintDialog"
      GTYPE = "GtkPrintDialog"
      FIELDS = [:accept_label, :modal, :page_setup, :print_settings, :title].freeze
      PROPERTIES = {accept_label: "accept-label", modal: "modal", page_setup: "page-setup", print_settings: "print-settings", title: "title"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :accept_label, :modal, :page_setup, :print_settings, :title
    end
  end

  module Gtk
    class PrintJob < GtkAst::GObject::Object

      TYPE = "Gtk.PrintJob"
      GTYPE = "GtkPrintJob"
      FIELDS = [:page_setup, :printer, :settings, :title, :track_print_status].freeze
      PROPERTIES = {page_setup: "page-setup", printer: "printer", settings: "settings", title: "title", track_print_status: "track-print-status"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :page_setup, :printer, :settings, :title, :track_print_status
    end
  end

  module Gtk
    class PrintOperation < GtkAst::GObject::Object
      include PrintOperationPreview

      TYPE = "Gtk.PrintOperation"
      GTYPE = "GtkPrintOperation"
      FIELDS = [:allow_async, :current_page, :custom_tab_label, :default_page_setup, :embed_page_setup, :export_filename, :has_selection, :job_name, :n_pages, :n_pages_to_print, :print_settings, :show_progress, :status, :status_string, :support_selection, :track_print_status, :unit, :use_full_page].freeze
      PROPERTIES = {allow_async: "allow-async", current_page: "current-page", custom_tab_label: "custom-tab-label", default_page_setup: "default-page-setup", embed_page_setup: "embed-page-setup", export_filename: "export-filename", has_selection: "has-selection", job_name: "job-name", n_pages: "n-pages", n_pages_to_print: "n-pages-to-print", print_settings: "print-settings", show_progress: "show-progress", status: "status", status_string: "status-string", support_selection: "support-selection", track_print_status: "track-print-status", unit: "unit", use_full_page: "use-full-page"}.freeze
      KEYS = (superclass::KEYS + PrintOperationPreview::FIELDS + FIELDS).uniq.freeze
      STATUS_DOMAIN = [:initial, :preparing, :generating_data, :sending_data, :pending, :pending_issue, :printing, :finished, :finished_aborted].freeze
      UNIT_DOMAIN = [:none, :points, :inch, :mm].freeze

      attr_reader :allow_async, :current_page, :custom_tab_label, :default_page_setup, :embed_page_setup, :export_filename, :has_selection, :job_name, :n_pages, :n_pages_to_print, :print_settings, :show_progress, :status, :status_string, :support_selection, :track_print_status, :unit, :use_full_page
    end
  end

  module Gtk
    class PrintSettings < GtkAst::GObject::Object

      TYPE = "Gtk.PrintSettings"
      GTYPE = "GtkPrintSettings"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class PrintUnixDialog < Dialog
      include Accessible
      include Buildable
      include ConstraintTarget
      include Native
      include Root
      include ShortcutManager

      TYPE = "Gtk.PrintUnixDialog"
      GTYPE = "GtkPrintUnixDialog"
      FIELDS = [:current_page, :embed_page_setup, :has_selection, :manual_capabilities, :page_setup, :print_settings, :selected_printer, :support_selection].freeze
      PROPERTIES = {current_page: "current-page", embed_page_setup: "embed-page-setup", has_selection: "has-selection", manual_capabilities: "manual-capabilities", page_setup: "page-setup", print_settings: "print-settings", selected_printer: "selected-printer", support_selection: "support-selection"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + Root::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze
      MANUAL_CAPABILITIES_DOMAIN = [:page_set, :copies, :collate, :reverse, :scale, :generate_pdf, :generate_ps, :preview, :number_up, :number_up_layout].freeze

      attr_reader :current_page, :embed_page_setup, :has_selection, :manual_capabilities, :page_setup, :print_settings, :selected_printer, :support_selection
    end
  end

  module Gtk
    class Printer < GtkAst::GObject::Object

      TYPE = "Gtk.Printer"
      GTYPE = "GtkPrinter"
      FIELDS = [:accepting_jobs, :accepts_pdf, :accepts_ps, :backend, :icon_name, :is_virtual, :job_count, :location, :name, :paused, :state_message].freeze
      PROPERTIES = {accepting_jobs: "accepting-jobs", accepts_pdf: "accepts-pdf", accepts_ps: "accepts-ps", backend: "backend", icon_name: "icon-name", is_virtual: "is-virtual", job_count: "job-count", location: "location", name: "name", paused: "paused", state_message: "state-message"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :accepting_jobs, :accepts_pdf, :accepts_ps, :backend, :icon_name, :is_virtual, :job_count, :location, :name, :paused, :state_message
    end
  end

  module Gtk
    class ProgressBar < Widget
      include Accessible
      include AccessibleRange
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.ProgressBar"
      GTYPE = "GtkProgressBar"
      FIELDS = [:ellipsize, :fraction, :inverted, :pulse_step, :show_text, :text].freeze
      PROPERTIES = {ellipsize: "ellipsize", fraction: "fraction", inverted: "inverted", pulse_step: "pulse-step", show_text: "show-text", text: "text"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AccessibleRange::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze
      ELLIPSIZE_DOMAIN = [:none, :start, :middle, :end].freeze

      attr_reader :ellipsize, :fraction, :inverted, :pulse_step, :show_text, :text
    end
  end

  module Gtk
    class PropertyExpression < Expression

      TYPE = "Gtk.PropertyExpression"
      GTYPE = "GtkPropertyExpression"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class Range < Widget
      include Accessible
      include AccessibleRange
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.Range"
      GTYPE = "GtkRange"
      FIELDS = [:adjustment, :fill_level, :inverted, :restrict_to_fill_level, :round_digits, :show_fill_level].freeze
      PROPERTIES = {adjustment: "adjustment", fill_level: "fill-level", inverted: "inverted", restrict_to_fill_level: "restrict-to-fill-level", round_digits: "round-digits", show_fill_level: "show-fill-level"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AccessibleRange::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :adjustment, :fill_level, :inverted, :restrict_to_fill_level, :round_digits, :show_fill_level
    end
  end

  module Gtk
    class RecentManager < GtkAst::GObject::Object

      TYPE = "Gtk.RecentManager"
      GTYPE = "GtkRecentManager"
      FIELDS = [:filename, :size].freeze
      PROPERTIES = {filename: "filename", size: "size"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :filename, :size
    end
  end

  module Gtk
    class Revealer < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Revealer"
      GTYPE = "GtkRevealer"
      FIELDS = [:child, :child_revealed, :reveal_child, :transition_duration, :transition_type].freeze
      PROPERTIES = {child: "child", child_revealed: "child-revealed", reveal_child: "reveal-child", transition_duration: "transition-duration", transition_type: "transition-type"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      TRANSITION_TYPE_DOMAIN = [:none, :crossfade, :slide_right, :slide_left, :slide_up, :slide_down, :swing_right, :swing_left, :swing_up, :swing_down, :fade_slide_right, :fade_slide_left, :fade_slide_up, :fade_slide_down].freeze

      attr_reader :child, :child_revealed, :reveal_child, :transition_duration, :transition_type
    end
  end

  module Gtk
    class Scale < Range
      include Accessible
      include AccessibleRange
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.Scale"
      GTYPE = "GtkScale"
      FIELDS = [:digits, :draw_value, :has_origin, :value_pos].freeze
      PROPERTIES = {digits: "digits", draw_value: "draw-value", has_origin: "has-origin", value_pos: "value-pos"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AccessibleRange::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze
      VALUE_POS_DOMAIN = [:left, :right, :top, :bottom].freeze

      attr_reader :digits, :draw_value, :has_origin, :value_pos
    end
  end

  module Gtk
    class ScaleButton < Widget
      include Accessible
      include AccessibleRange
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.ScaleButton"
      GTYPE = "GtkScaleButton"
      FIELDS = [:active, :adjustment, :has_frame, :icons, :value].freeze
      PROPERTIES = {active: "active", adjustment: "adjustment", has_frame: "has-frame", icons: "icons", value: "value"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AccessibleRange::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :active, :adjustment, :has_frame, :icons, :value
    end
  end

  module Gtk
    class Scrollbar < Widget
      include Accessible
      include AccessibleRange
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.Scrollbar"
      GTYPE = "GtkScrollbar"
      FIELDS = [:adjustment].freeze
      PROPERTIES = {adjustment: "adjustment"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AccessibleRange::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :adjustment
    end
  end

  module Gtk
    class ScrolledWindow < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.ScrolledWindow"
      GTYPE = "GtkScrolledWindow"
      FIELDS = [:child, :hadjustment, :has_frame, :hscrollbar_policy, :kinetic_scrolling, :max_content_height, :max_content_width, :min_content_height, :min_content_width, :overlay_scrolling, :propagate_natural_height, :propagate_natural_width, :vadjustment, :vscrollbar_policy, :window_placement].freeze
      PROPERTIES = {child: "child", hadjustment: "hadjustment", has_frame: "has-frame", hscrollbar_policy: "hscrollbar-policy", kinetic_scrolling: "kinetic-scrolling", max_content_height: "max-content-height", max_content_width: "max-content-width", min_content_height: "min-content-height", min_content_width: "min-content-width", overlay_scrolling: "overlay-scrolling", propagate_natural_height: "propagate-natural-height", propagate_natural_width: "propagate-natural-width", vadjustment: "vadjustment", vscrollbar_policy: "vscrollbar-policy", window_placement: "window-placement"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      HSCROLLBAR_POLICY_DOMAIN = [:always, :automatic, :never, :external].freeze
      VSCROLLBAR_POLICY_DOMAIN = [:always, :automatic, :never, :external].freeze
      WINDOW_PLACEMENT_DOMAIN = [:top_left, :bottom_left, :top_right, :bottom_right].freeze

      attr_reader :child, :hadjustment, :has_frame, :hscrollbar_policy, :kinetic_scrolling, :max_content_height, :max_content_width, :min_content_height, :min_content_width, :overlay_scrolling, :propagate_natural_height, :propagate_natural_width, :vadjustment, :vscrollbar_policy, :window_placement
    end
  end

  module Gtk
    class SearchBar < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.SearchBar"
      GTYPE = "GtkSearchBar"
      FIELDS = [:child, :key_capture_widget, :search_mode_enabled, :show_close_button].freeze
      PROPERTIES = {child: "child", key_capture_widget: "key-capture-widget", search_mode_enabled: "search-mode-enabled", show_close_button: "show-close-button"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :child, :key_capture_widget, :search_mode_enabled, :show_close_button
    end
  end

  module Gtk
    class SearchEntry < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Editable

      TYPE = "Gtk.SearchEntry"
      GTYPE = "GtkSearchEntry"
      FIELDS = [:activates_default, :input_hints, :input_purpose, :key_capture_widget, :placeholder_text, :search_delay].freeze
      PROPERTIES = {activates_default: "activates-default", input_hints: "input-hints", input_purpose: "input-purpose", key_capture_widget: "key-capture-widget", placeholder_text: "placeholder-text", search_delay: "search-delay"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Editable::FIELDS + FIELDS).uniq.freeze
      INPUT_HINTS_DOMAIN = [:none, :spellcheck, :no_spellcheck, :word_completion, :lowercase, :uppercase_chars, :uppercase_words, :uppercase_sentences, :inhibit_osk, :vertical_writing, :emoji, :no_emoji, :private].freeze
      INPUT_PURPOSE_DOMAIN = [:free_form, :alpha, :digits, :number, :phone, :url, :email, :name, :password, :pin, :terminal].freeze

      attr_reader :activates_default, :input_hints, :input_purpose, :key_capture_widget, :placeholder_text, :search_delay
    end
  end

  module Gtk
    class SelectionFilterModel < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel

      TYPE = "Gtk.SelectionFilterModel"
      GTYPE = "GtkSelectionFilterModel"
      FIELDS = [:item_type, :model, :n_items].freeze
      PROPERTIES = {item_type: "item-type", model: "model", n_items: "n-items"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :item_type, :model, :n_items
    end
  end

  module Gtk
    class Separator < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.Separator"
      GTYPE = "GtkSeparator"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class Settings < GtkAst::GObject::Object
      include StyleProvider

      TYPE = "Gtk.Settings"
      GTYPE = "GtkSettings"
      FIELDS = [:gtk_alternative_button_order, :gtk_alternative_sort_arrows, :gtk_application_prefer_dark_theme, :gtk_cursor_aspect_ratio, :gtk_cursor_blink, :gtk_cursor_blink_time, :gtk_cursor_blink_timeout, :gtk_cursor_theme_name, :gtk_cursor_theme_size, :gtk_decoration_layout, :gtk_dialogs_use_header, :gtk_dnd_drag_threshold, :gtk_double_click_distance, :gtk_double_click_time, :gtk_enable_accels, :gtk_enable_animations, :gtk_enable_event_sounds, :gtk_enable_input_feedback_sounds, :gtk_enable_primary_paste, :gtk_entry_password_hint_timeout, :gtk_entry_select_on_focus, :gtk_error_bell, :gtk_font_name, :gtk_font_rendering, :gtk_fontconfig_timestamp, :gtk_hint_font_metrics, :gtk_icon_theme_name, :gtk_im_module, :gtk_interface_color_scheme, :gtk_interface_contrast, :gtk_interface_reduced_motion, :gtk_keynav_use_caret, :gtk_label_select_on_focus, :gtk_long_press_time, :gtk_overlay_scrolling, :gtk_primary_button_warps_slider, :gtk_print_backends, :gtk_print_preview_command, :gtk_recent_files_enabled, :gtk_recent_files_max_age, :gtk_shell_shows_app_menu, :gtk_shell_shows_desktop, :gtk_shell_shows_menubar, :gtk_show_status_shapes, :gtk_sound_theme_name, :gtk_split_cursor, :gtk_theme_name, :gtk_titlebar_double_click, :gtk_titlebar_middle_click, :gtk_titlebar_right_click, :gtk_xft_antialias, :gtk_xft_dpi, :gtk_xft_hinting, :gtk_xft_hintstyle, :gtk_xft_rgba].freeze
      PROPERTIES = {gtk_alternative_button_order: "gtk-alternative-button-order", gtk_alternative_sort_arrows: "gtk-alternative-sort-arrows", gtk_application_prefer_dark_theme: "gtk-application-prefer-dark-theme", gtk_cursor_aspect_ratio: "gtk-cursor-aspect-ratio", gtk_cursor_blink: "gtk-cursor-blink", gtk_cursor_blink_time: "gtk-cursor-blink-time", gtk_cursor_blink_timeout: "gtk-cursor-blink-timeout", gtk_cursor_theme_name: "gtk-cursor-theme-name", gtk_cursor_theme_size: "gtk-cursor-theme-size", gtk_decoration_layout: "gtk-decoration-layout", gtk_dialogs_use_header: "gtk-dialogs-use-header", gtk_dnd_drag_threshold: "gtk-dnd-drag-threshold", gtk_double_click_distance: "gtk-double-click-distance", gtk_double_click_time: "gtk-double-click-time", gtk_enable_accels: "gtk-enable-accels", gtk_enable_animations: "gtk-enable-animations", gtk_enable_event_sounds: "gtk-enable-event-sounds", gtk_enable_input_feedback_sounds: "gtk-enable-input-feedback-sounds", gtk_enable_primary_paste: "gtk-enable-primary-paste", gtk_entry_password_hint_timeout: "gtk-entry-password-hint-timeout", gtk_entry_select_on_focus: "gtk-entry-select-on-focus", gtk_error_bell: "gtk-error-bell", gtk_font_name: "gtk-font-name", gtk_font_rendering: "gtk-font-rendering", gtk_fontconfig_timestamp: "gtk-fontconfig-timestamp", gtk_hint_font_metrics: "gtk-hint-font-metrics", gtk_icon_theme_name: "gtk-icon-theme-name", gtk_im_module: "gtk-im-module", gtk_interface_color_scheme: "gtk-interface-color-scheme", gtk_interface_contrast: "gtk-interface-contrast", gtk_interface_reduced_motion: "gtk-interface-reduced-motion", gtk_keynav_use_caret: "gtk-keynav-use-caret", gtk_label_select_on_focus: "gtk-label-select-on-focus", gtk_long_press_time: "gtk-long-press-time", gtk_overlay_scrolling: "gtk-overlay-scrolling", gtk_primary_button_warps_slider: "gtk-primary-button-warps-slider", gtk_print_backends: "gtk-print-backends", gtk_print_preview_command: "gtk-print-preview-command", gtk_recent_files_enabled: "gtk-recent-files-enabled", gtk_recent_files_max_age: "gtk-recent-files-max-age", gtk_shell_shows_app_menu: "gtk-shell-shows-app-menu", gtk_shell_shows_desktop: "gtk-shell-shows-desktop", gtk_shell_shows_menubar: "gtk-shell-shows-menubar", gtk_show_status_shapes: "gtk-show-status-shapes", gtk_sound_theme_name: "gtk-sound-theme-name", gtk_split_cursor: "gtk-split-cursor", gtk_theme_name: "gtk-theme-name", gtk_titlebar_double_click: "gtk-titlebar-double-click", gtk_titlebar_middle_click: "gtk-titlebar-middle-click", gtk_titlebar_right_click: "gtk-titlebar-right-click", gtk_xft_antialias: "gtk-xft-antialias", gtk_xft_dpi: "gtk-xft-dpi", gtk_xft_hinting: "gtk-xft-hinting", gtk_xft_hintstyle: "gtk-xft-hintstyle", gtk_xft_rgba: "gtk-xft-rgba"}.freeze
      KEYS = (superclass::KEYS + StyleProvider::FIELDS + FIELDS).uniq.freeze
      GTK_FONT_RENDERING_DOMAIN = [:automatic, :manual].freeze
      GTK_INTERFACE_COLOR_SCHEME_DOMAIN = [:unsupported, :default, :dark, :light].freeze
      GTK_INTERFACE_CONTRAST_DOMAIN = [:unsupported, :no_preference, :more, :less].freeze
      GTK_INTERFACE_REDUCED_MOTION_DOMAIN = [:no_preference, :reduce].freeze

      attr_reader :gtk_alternative_button_order, :gtk_alternative_sort_arrows, :gtk_application_prefer_dark_theme, :gtk_cursor_aspect_ratio, :gtk_cursor_blink, :gtk_cursor_blink_time, :gtk_cursor_blink_timeout, :gtk_cursor_theme_name, :gtk_cursor_theme_size, :gtk_decoration_layout, :gtk_dialogs_use_header, :gtk_dnd_drag_threshold, :gtk_double_click_distance, :gtk_double_click_time, :gtk_enable_accels, :gtk_enable_animations, :gtk_enable_event_sounds, :gtk_enable_input_feedback_sounds, :gtk_enable_primary_paste, :gtk_entry_password_hint_timeout, :gtk_entry_select_on_focus, :gtk_error_bell, :gtk_font_name, :gtk_font_rendering, :gtk_fontconfig_timestamp, :gtk_hint_font_metrics, :gtk_icon_theme_name, :gtk_im_module, :gtk_interface_color_scheme, :gtk_interface_contrast, :gtk_interface_reduced_motion, :gtk_keynav_use_caret, :gtk_label_select_on_focus, :gtk_long_press_time, :gtk_overlay_scrolling, :gtk_primary_button_warps_slider, :gtk_print_backends, :gtk_print_preview_command, :gtk_recent_files_enabled, :gtk_recent_files_max_age, :gtk_shell_shows_app_menu, :gtk_shell_shows_desktop, :gtk_shell_shows_menubar, :gtk_show_status_shapes, :gtk_sound_theme_name, :gtk_split_cursor, :gtk_theme_name, :gtk_titlebar_double_click, :gtk_titlebar_middle_click, :gtk_titlebar_right_click, :gtk_xft_antialias, :gtk_xft_dpi, :gtk_xft_hinting, :gtk_xft_hintstyle, :gtk_xft_rgba
    end
  end

  module Gtk
    class Shortcut < GtkAst::GObject::Object

      TYPE = "Gtk.Shortcut"
      GTYPE = "GtkShortcut"
      FIELDS = [:action, :arguments, :trigger].freeze
      PROPERTIES = {action: "action", arguments: "arguments", trigger: "trigger"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :action, :arguments, :trigger
    end
  end

  module Gtk
    class ShortcutController < EventController
      include GtkAst::Gio::ListModel
      include Buildable

      TYPE = "Gtk.ShortcutController"
      GTYPE = "GtkShortcutController"
      FIELDS = [:item_type, :mnemonic_modifiers, :model, :n_items, :scope].freeze
      PROPERTIES = {item_type: "item-type", mnemonic_modifiers: "mnemonic-modifiers", model: "model", n_items: "n-items", scope: "scope"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + Buildable::FIELDS + FIELDS).uniq.freeze
      MNEMONIC_MODIFIERS_DOMAIN = [:no_modifier_mask, :shift_mask, :lock_mask, :control_mask, :alt_mask, :button1_mask, :button2_mask, :button3_mask, :button4_mask, :button5_mask, :super_mask, :hyper_mask, :meta_mask].freeze
      SCOPE_DOMAIN = [:local, :managed, :global].freeze

      attr_reader :item_type, :mnemonic_modifiers, :model, :n_items, :scope
    end
  end

  module Gtk
    class ShortcutLabel < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.ShortcutLabel"
      GTYPE = "GtkShortcutLabel"
      FIELDS = [:accelerator, :disabled_text].freeze
      PROPERTIES = {accelerator: "accelerator", disabled_text: "disabled-text"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :accelerator, :disabled_text
    end
  end

  module Gtk
    class ShortcutsGroup < Box
      include Accessible
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.ShortcutsGroup"
      GTYPE = "GtkShortcutsGroup"
      FIELDS = [:accel_size_group, :height, :title, :title_size_group, :view].freeze
      PROPERTIES = {accel_size_group: "accel-size-group", height: "height", title: "title", title_size_group: "title-size-group", view: "view"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :accel_size_group, :height, :title, :title_size_group, :view
    end
  end

  module Gtk
    class ShortcutsSection < Box
      include Accessible
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.ShortcutsSection"
      GTYPE = "GtkShortcutsSection"
      FIELDS = [:max_height, :section_name, :title, :view_name].freeze
      PROPERTIES = {max_height: "max-height", section_name: "section-name", title: "title", view_name: "view-name"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :max_height, :section_name, :title, :view_name
    end
  end

  module Gtk
    class ShortcutsShortcut < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.ShortcutsShortcut"
      GTYPE = "GtkShortcutsShortcut"
      FIELDS = [:accel_size_group, :accelerator, :action_name, :direction, :icon, :icon_set, :shortcut_type, :subtitle, :subtitle_set, :title, :title_size_group].freeze
      PROPERTIES = {accel_size_group: "accel-size-group", accelerator: "accelerator", action_name: "action-name", direction: "direction", icon: "icon", icon_set: "icon-set", shortcut_type: "shortcut-type", subtitle: "subtitle", subtitle_set: "subtitle-set", title: "title", title_size_group: "title-size-group"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      DIRECTION_DOMAIN = [:none, :ltr, :rtl].freeze
      SHORTCUT_TYPE_DOMAIN = [:accelerator, :gesture_pinch, :gesture_stretch, :gesture_rotate_clockwise, :gesture_rotate_counterclockwise, :gesture_two_finger_swipe_left, :gesture_two_finger_swipe_right, :gesture, :gesture_swipe_left, :gesture_swipe_right].freeze

      attr_reader :accel_size_group, :accelerator, :action_name, :direction, :icon, :icon_set, :shortcut_type, :subtitle, :subtitle_set, :title, :title_size_group
    end
  end

  module Gtk
    class ShortcutsWindow < Window
      include Accessible
      include Buildable
      include ConstraintTarget
      include Native
      include Root
      include ShortcutManager

      TYPE = "Gtk.ShortcutsWindow"
      GTYPE = "GtkShortcutsWindow"
      FIELDS = [:section_name, :view_name].freeze
      PROPERTIES = {section_name: "section-name", view_name: "view-name"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Native::FIELDS + Root::FIELDS + ShortcutManager::FIELDS + FIELDS).uniq.freeze

      attr_reader :section_name, :view_name
    end
  end

  module Gtk
    class SignalAction < ShortcutAction

      TYPE = "Gtk.SignalAction"
      GTYPE = "GtkSignalAction"
      FIELDS = [:signal_name].freeze
      PROPERTIES = {signal_name: "signal-name"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :signal_name
    end
  end

  module Gtk
    class SignalListItemFactory < ListItemFactory

      TYPE = "Gtk.SignalListItemFactory"
      GTYPE = "GtkSignalListItemFactory"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class SingleSelection < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel
      include SectionModel
      include SelectionModel

      TYPE = "Gtk.SingleSelection"
      GTYPE = "GtkSingleSelection"
      FIELDS = [:autoselect, :can_unselect, :item_type, :model, :n_items, :selected, :selected_item].freeze
      PROPERTIES = {autoselect: "autoselect", can_unselect: "can-unselect", item_type: "item-type", model: "model", n_items: "n-items", selected: "selected", selected_item: "selected-item"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + SectionModel::FIELDS + SelectionModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :autoselect, :can_unselect, :item_type, :model, :n_items, :selected, :selected_item
    end
  end

  module Gtk
    class SizeGroup < GtkAst::GObject::Object
      include Buildable

      TYPE = "Gtk.SizeGroup"
      GTYPE = "GtkSizeGroup"
      FIELDS = [:mode].freeze
      PROPERTIES = {mode: "mode"}.freeze
      KEYS = (superclass::KEYS + Buildable::FIELDS + FIELDS).uniq.freeze
      MODE_DOMAIN = [:none, :horizontal, :vertical, :both].freeze

      attr_reader :mode
    end
  end

  module Gtk
    class SliceListModel < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel
      include SectionModel

      TYPE = "Gtk.SliceListModel"
      GTYPE = "GtkSliceListModel"
      FIELDS = [:item_type, :model, :n_items, :offset, :size].freeze
      PROPERTIES = {item_type: "item-type", model: "model", n_items: "n-items", offset: "offset", size: "size"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + SectionModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :item_type, :model, :n_items, :offset, :size
    end
  end

  module Gtk
    class Snapshot < GtkAst::Gdk::Snapshot

      TYPE = "Gtk.Snapshot"
      GTYPE = "GtkSnapshot"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class SortListModel < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel
      include SectionModel

      TYPE = "Gtk.SortListModel"
      GTYPE = "GtkSortListModel"
      FIELDS = [:incremental, :item_type, :model, :n_items, :pending, :section_sorter, :sorter].freeze
      PROPERTIES = {incremental: "incremental", item_type: "item-type", model: "model", n_items: "n-items", pending: "pending", section_sorter: "section-sorter", sorter: "sorter"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + SectionModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :incremental, :item_type, :model, :n_items, :pending, :section_sorter, :sorter
    end
  end

  module Gtk
    class SpinButton < Widget
      include Accessible
      include AccessibleRange
      include Buildable
      include CellEditable
      include ConstraintTarget
      include Editable
      include Orientable

      TYPE = "Gtk.SpinButton"
      GTYPE = "GtkSpinButton"
      FIELDS = [:activates_default, :adjustment, :climb_rate, :digits, :numeric, :snap_to_ticks, :update_policy, :value, :wrap].freeze
      PROPERTIES = {activates_default: "activates-default", adjustment: "adjustment", climb_rate: "climb-rate", digits: "digits", numeric: "numeric", snap_to_ticks: "snap-to-ticks", update_policy: "update-policy", value: "value", wrap: "wrap"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AccessibleRange::FIELDS + Buildable::FIELDS + CellEditable::FIELDS + ConstraintTarget::FIELDS + Editable::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze
      UPDATE_POLICY_DOMAIN = [:always, :if_valid].freeze

      attr_reader :activates_default, :adjustment, :climb_rate, :digits, :numeric, :snap_to_ticks, :update_policy, :value, :wrap
    end
  end

  module Gtk
    class Spinner < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Spinner"
      GTYPE = "GtkSpinner"
      FIELDS = [:spinning].freeze
      PROPERTIES = {spinning: "spinning"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :spinning
    end
  end

  module Gtk
    class Stack < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Stack"
      GTYPE = "GtkStack"
      FIELDS = [:hhomogeneous, :interpolate_size, :pages, :transition_duration, :transition_running, :transition_type, :vhomogeneous, :visible_child, :visible_child_name].freeze
      PROPERTIES = {hhomogeneous: "hhomogeneous", interpolate_size: "interpolate-size", pages: "pages", transition_duration: "transition-duration", transition_running: "transition-running", transition_type: "transition-type", vhomogeneous: "vhomogeneous", visible_child: "visible-child", visible_child_name: "visible-child-name"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      TRANSITION_TYPE_DOMAIN = [:none, :crossfade, :slide_right, :slide_left, :slide_up, :slide_down, :slide_left_right, :slide_up_down, :over_up, :over_down, :over_left, :over_right, :under_up, :under_down, :under_left, :under_right, :over_up_down, :over_down_up, :over_left_right, :over_right_left, :rotate_left, :rotate_right, :rotate_left_right].freeze

      attr_reader :hhomogeneous, :interpolate_size, :pages, :transition_duration, :transition_running, :transition_type, :vhomogeneous, :visible_child, :visible_child_name
    end
  end

  module Gtk
    class StackPage < GtkAst::GObject::Object
      include Accessible

      TYPE = "Gtk.StackPage"
      GTYPE = "GtkStackPage"
      FIELDS = [:child, :icon_name, :name, :needs_attention, :title, :use_underline, :visible].freeze
      PROPERTIES = {child: "child", icon_name: "icon-name", name: "name", needs_attention: "needs-attention", title: "title", use_underline: "use-underline", visible: "visible"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + FIELDS).uniq.freeze

      attr_reader :child, :icon_name, :name, :needs_attention, :title, :use_underline, :visible
    end
  end

  module Gtk
    class StackSidebar < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.StackSidebar"
      GTYPE = "GtkStackSidebar"
      FIELDS = [:stack].freeze
      PROPERTIES = {stack: "stack"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :stack
    end
  end

  module Gtk
    class StackSwitcher < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.StackSwitcher"
      GTYPE = "GtkStackSwitcher"
      FIELDS = [:stack].freeze
      PROPERTIES = {stack: "stack"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :stack
    end
  end

  module Gtk
    class Statusbar < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Statusbar"
      GTYPE = "GtkStatusbar"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class StringFilter < Filter

      TYPE = "Gtk.StringFilter"
      GTYPE = "GtkStringFilter"
      FIELDS = [:expression, :ignore_case, :match_mode, :search].freeze
      PROPERTIES = {expression: "expression", ignore_case: "ignore-case", match_mode: "match-mode", search: "search"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      MATCH_MODE_DOMAIN = [:exact, :substring, :prefix].freeze

      attr_reader :expression, :ignore_case, :match_mode, :search
    end
  end

  module Gtk
    class StringList < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel
      include Buildable

      TYPE = "Gtk.StringList"
      GTYPE = "GtkStringList"
      FIELDS = [:item_type, :n_items, :strings].freeze
      PROPERTIES = {item_type: "item-type", n_items: "n-items", strings: "strings"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + Buildable::FIELDS + FIELDS).uniq.freeze

      attr_reader :item_type, :n_items, :strings
    end
  end

  module Gtk
    class StringObject < GtkAst::GObject::Object

      TYPE = "Gtk.StringObject"
      GTYPE = "GtkStringObject"
      FIELDS = [:string].freeze
      PROPERTIES = {string: "string"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :string
    end
  end

  module Gtk
    class StringSorter < Sorter

      TYPE = "Gtk.StringSorter"
      GTYPE = "GtkStringSorter"
      FIELDS = [:collation, :expression, :ignore_case].freeze
      PROPERTIES = {collation: "collation", expression: "expression", ignore_case: "ignore-case"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      COLLATION_DOMAIN = [:none, :unicode, :filename].freeze

      attr_reader :collation, :expression, :ignore_case
    end
  end

  module Gtk
    class StyleContext < GtkAst::GObject::Object

      TYPE = "Gtk.StyleContext"
      GTYPE = "GtkStyleContext"
      FIELDS = [:display].freeze
      PROPERTIES = {display: "display"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :display
    end
  end

  module Gtk
    class Svg < GtkAst::GObject::Object
      include GtkAst::Gdk::Paintable
      include SymbolicPaintable

      TYPE = "Gtk.Svg"
      GTYPE = "GtkSvg"
      FIELDS = [:features, :playing, :resource, :state, :weight].freeze
      PROPERTIES = {features: "features", playing: "playing", resource: "resource", state: "state", weight: "weight"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gdk::Paintable::FIELDS + SymbolicPaintable::FIELDS + FIELDS).uniq.freeze
      FEATURES_DOMAIN = [:animations, :system_resources, :external_resources, :extensions, :traditional_symbolic].freeze

      attr_reader :features, :playing, :resource, :state, :weight
    end
  end

  module Gtk
    class Switch < Widget
      include Accessible
      include Actionable
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Switch"
      GTYPE = "GtkSwitch"
      FIELDS = [:active, :state].freeze
      PROPERTIES = {active: "active", state: "state"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Actionable::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :active, :state
    end
  end

  module Gtk
    class Text < Widget
      include Accessible
      include AccessibleText
      include Buildable
      include ConstraintTarget
      include Editable

      TYPE = "Gtk.Text"
      GTYPE = "GtkText"
      FIELDS = [:activates_default, :attributes, :buffer, :enable_emoji_completion, :extra_menu, :im_module, :input_hints, :input_purpose, :invisible_char, :invisible_char_set, :max_length, :overwrite_mode, :placeholder_text, :propagate_text_width, :scroll_offset, :tabs, :truncate_multiline, :visibility].freeze
      PROPERTIES = {activates_default: "activates-default", attributes: "attributes", buffer: "buffer", enable_emoji_completion: "enable-emoji-completion", extra_menu: "extra-menu", im_module: "im-module", input_hints: "input-hints", input_purpose: "input-purpose", invisible_char: "invisible-char", invisible_char_set: "invisible-char-set", max_length: "max-length", overwrite_mode: "overwrite-mode", placeholder_text: "placeholder-text", propagate_text_width: "propagate-text-width", scroll_offset: "scroll-offset", tabs: "tabs", truncate_multiline: "truncate-multiline", visibility: "visibility"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AccessibleText::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Editable::FIELDS + FIELDS).uniq.freeze
      INPUT_HINTS_DOMAIN = [:none, :spellcheck, :no_spellcheck, :word_completion, :lowercase, :uppercase_chars, :uppercase_words, :uppercase_sentences, :inhibit_osk, :vertical_writing, :emoji, :no_emoji, :private].freeze
      INPUT_PURPOSE_DOMAIN = [:free_form, :alpha, :digits, :number, :phone, :url, :email, :name, :password, :pin, :terminal].freeze

      attr_reader :activates_default, :attributes, :buffer, :enable_emoji_completion, :extra_menu, :im_module, :input_hints, :input_purpose, :invisible_char, :invisible_char_set, :max_length, :overwrite_mode, :placeholder_text, :propagate_text_width, :scroll_offset, :tabs, :truncate_multiline, :visibility
    end
  end

  module Gtk
    class TextBuffer < GtkAst::GObject::Object

      TYPE = "Gtk.TextBuffer"
      GTYPE = "GtkTextBuffer"
      FIELDS = [:can_redo, :can_undo, :cursor_position, :enable_undo, :has_selection, :tag_table, :text].freeze
      PROPERTIES = {can_redo: "can-redo", can_undo: "can-undo", cursor_position: "cursor-position", enable_undo: "enable-undo", has_selection: "has-selection", tag_table: "tag-table", text: "text"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :can_redo, :can_undo, :cursor_position, :enable_undo, :has_selection, :tag_table, :text
    end
  end

  module Gtk
    class TextChildAnchor < GtkAst::GObject::Object

      TYPE = "Gtk.TextChildAnchor"
      GTYPE = "GtkTextChildAnchor"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class TextMark < GtkAst::GObject::Object

      TYPE = "Gtk.TextMark"
      GTYPE = "GtkTextMark"
      FIELDS = [:left_gravity, :name].freeze
      PROPERTIES = {left_gravity: "left-gravity", name: "name"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :left_gravity, :name
    end
  end

  module Gtk
    class TextTag < GtkAst::GObject::Object

      TYPE = "Gtk.TextTag"
      GTYPE = "GtkTextTag"
      FIELDS = [:accumulative_margin, :allow_breaks, :allow_breaks_set, :background, :background_full_height, :background_full_height_set, :background_rgba, :background_set, :direction, :editable, :editable_set, :fallback, :fallback_set, :family, :family_set, :font, :font_desc, :font_features, :font_features_set, :foreground, :foreground_rgba, :foreground_set, :indent, :indent_set, :insert_hyphens, :insert_hyphens_set, :invisible, :invisible_set, :justification, :justification_set, :language, :language_set, :left_margin, :left_margin_set, :letter_spacing, :letter_spacing_set, :line_height, :line_height_set, :name, :overline, :overline_rgba, :overline_rgba_set, :overline_set, :paragraph_background, :paragraph_background_rgba, :paragraph_background_set, :pixels_above_lines, :pixels_above_lines_set, :pixels_below_lines, :pixels_below_lines_set, :pixels_inside_wrap, :pixels_inside_wrap_set, :right_margin, :right_margin_set, :rise, :rise_set, :scale, :scale_set, :sentence, :sentence_set, :show_spaces, :show_spaces_set, :size, :size_points, :size_set, :stretch, :stretch_set, :strikethrough, :strikethrough_rgba, :strikethrough_rgba_set, :strikethrough_set, :style, :style_set, :tabs, :tabs_set, :text_transform, :text_transform_set, :underline, :underline_rgba, :underline_rgba_set, :underline_set, :variant, :variant_set, :weight, :weight_set, :word, :word_set, :wrap_mode, :wrap_mode_set].freeze
      PROPERTIES = {accumulative_margin: "accumulative-margin", allow_breaks: "allow-breaks", allow_breaks_set: "allow-breaks-set", background: "background", background_full_height: "background-full-height", background_full_height_set: "background-full-height-set", background_rgba: "background-rgba", background_set: "background-set", direction: "direction", editable: "editable", editable_set: "editable-set", fallback: "fallback", fallback_set: "fallback-set", family: "family", family_set: "family-set", font: "font", font_desc: "font-desc", font_features: "font-features", font_features_set: "font-features-set", foreground: "foreground", foreground_rgba: "foreground-rgba", foreground_set: "foreground-set", indent: "indent", indent_set: "indent-set", insert_hyphens: "insert-hyphens", insert_hyphens_set: "insert-hyphens-set", invisible: "invisible", invisible_set: "invisible-set", justification: "justification", justification_set: "justification-set", language: "language", language_set: "language-set", left_margin: "left-margin", left_margin_set: "left-margin-set", letter_spacing: "letter-spacing", letter_spacing_set: "letter-spacing-set", line_height: "line-height", line_height_set: "line-height-set", name: "name", overline: "overline", overline_rgba: "overline-rgba", overline_rgba_set: "overline-rgba-set", overline_set: "overline-set", paragraph_background: "paragraph-background", paragraph_background_rgba: "paragraph-background-rgba", paragraph_background_set: "paragraph-background-set", pixels_above_lines: "pixels-above-lines", pixels_above_lines_set: "pixels-above-lines-set", pixels_below_lines: "pixels-below-lines", pixels_below_lines_set: "pixels-below-lines-set", pixels_inside_wrap: "pixels-inside-wrap", pixels_inside_wrap_set: "pixels-inside-wrap-set", right_margin: "right-margin", right_margin_set: "right-margin-set", rise: "rise", rise_set: "rise-set", scale: "scale", scale_set: "scale-set", sentence: "sentence", sentence_set: "sentence-set", show_spaces: "show-spaces", show_spaces_set: "show-spaces-set", size: "size", size_points: "size-points", size_set: "size-set", stretch: "stretch", stretch_set: "stretch-set", strikethrough: "strikethrough", strikethrough_rgba: "strikethrough-rgba", strikethrough_rgba_set: "strikethrough-rgba-set", strikethrough_set: "strikethrough-set", style: "style", style_set: "style-set", tabs: "tabs", tabs_set: "tabs-set", text_transform: "text-transform", text_transform_set: "text-transform-set", underline: "underline", underline_rgba: "underline-rgba", underline_rgba_set: "underline-rgba-set", underline_set: "underline-set", variant: "variant", variant_set: "variant-set", weight: "weight", weight_set: "weight-set", word: "word", word_set: "word-set", wrap_mode: "wrap-mode", wrap_mode_set: "wrap-mode-set"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      DIRECTION_DOMAIN = [:none, :ltr, :rtl].freeze
      JUSTIFICATION_DOMAIN = [:left, :right, :center, :fill].freeze
      OVERLINE_DOMAIN = [:none, :single].freeze
      SHOW_SPACES_DOMAIN = [:none, :spaces, :line_breaks, :ignorables].freeze
      STRETCH_DOMAIN = [:ultra_condensed, :extra_condensed, :condensed, :semi_condensed, :normal, :semi_expanded, :expanded, :extra_expanded, :ultra_expanded].freeze
      STYLE_DOMAIN = [:normal, :oblique, :italic].freeze
      TEXT_TRANSFORM_DOMAIN = [:none, :lowercase, :uppercase, :capitalize].freeze
      UNDERLINE_DOMAIN = [:none, :single, :double, :low, :error, :single_line, :double_line, :error_line].freeze
      VARIANT_DOMAIN = [:normal, :small_caps, :all_small_caps, :petite_caps, :all_petite_caps, :unicase, :title_caps].freeze
      WRAP_MODE_DOMAIN = [:none, :char, :word, :word_char].freeze

      attr_reader :accumulative_margin, :allow_breaks, :allow_breaks_set, :background, :background_full_height, :background_full_height_set, :background_rgba, :background_set, :direction, :editable, :editable_set, :fallback, :fallback_set, :family, :family_set, :font, :font_desc, :font_features, :font_features_set, :foreground, :foreground_rgba, :foreground_set, :indent, :indent_set, :insert_hyphens, :insert_hyphens_set, :invisible, :invisible_set, :justification, :justification_set, :language, :language_set, :left_margin, :left_margin_set, :letter_spacing, :letter_spacing_set, :line_height, :line_height_set, :name, :overline, :overline_rgba, :overline_rgba_set, :overline_set, :paragraph_background, :paragraph_background_rgba, :paragraph_background_set, :pixels_above_lines, :pixels_above_lines_set, :pixels_below_lines, :pixels_below_lines_set, :pixels_inside_wrap, :pixels_inside_wrap_set, :right_margin, :right_margin_set, :rise, :rise_set, :scale, :scale_set, :sentence, :sentence_set, :show_spaces, :show_spaces_set, :size, :size_points, :size_set, :stretch, :stretch_set, :strikethrough, :strikethrough_rgba, :strikethrough_rgba_set, :strikethrough_set, :style, :style_set, :tabs, :tabs_set, :text_transform, :text_transform_set, :underline, :underline_rgba, :underline_rgba_set, :underline_set, :variant, :variant_set, :weight, :weight_set, :word, :word_set, :wrap_mode, :wrap_mode_set
    end
  end

  module Gtk
    class TextTagTable < GtkAst::GObject::Object
      include Buildable

      TYPE = "Gtk.TextTagTable"
      GTYPE = "GtkTextTagTable"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Buildable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class TextView < Widget
      include Accessible
      include AccessibleText
      include Buildable
      include ConstraintTarget
      include Scrollable

      TYPE = "Gtk.TextView"
      GTYPE = "GtkTextView"
      FIELDS = [:accepts_tab, :bottom_margin, :buffer, :cursor_visible, :editable, :extra_menu, :im_module, :indent, :input_hints, :input_purpose, :justification, :left_margin, :monospace, :overwrite, :pixels_above_lines, :pixels_below_lines, :pixels_inside_wrap, :right_margin, :tabs, :top_margin, :wrap_mode].freeze
      PROPERTIES = {accepts_tab: "accepts-tab", bottom_margin: "bottom-margin", buffer: "buffer", cursor_visible: "cursor-visible", editable: "editable", extra_menu: "extra-menu", im_module: "im-module", indent: "indent", input_hints: "input-hints", input_purpose: "input-purpose", justification: "justification", left_margin: "left-margin", monospace: "monospace", overwrite: "overwrite", pixels_above_lines: "pixels-above-lines", pixels_below_lines: "pixels-below-lines", pixels_inside_wrap: "pixels-inside-wrap", right_margin: "right-margin", tabs: "tabs", top_margin: "top-margin", wrap_mode: "wrap-mode"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AccessibleText::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Scrollable::FIELDS + FIELDS).uniq.freeze
      INPUT_HINTS_DOMAIN = [:none, :spellcheck, :no_spellcheck, :word_completion, :lowercase, :uppercase_chars, :uppercase_words, :uppercase_sentences, :inhibit_osk, :vertical_writing, :emoji, :no_emoji, :private].freeze
      INPUT_PURPOSE_DOMAIN = [:free_form, :alpha, :digits, :number, :phone, :url, :email, :name, :password, :pin, :terminal].freeze
      JUSTIFICATION_DOMAIN = [:left, :right, :center, :fill].freeze
      WRAP_MODE_DOMAIN = [:none, :char, :word, :word_char].freeze

      attr_reader :accepts_tab, :bottom_margin, :buffer, :cursor_visible, :editable, :extra_menu, :im_module, :indent, :input_hints, :input_purpose, :justification, :left_margin, :monospace, :overwrite, :pixels_above_lines, :pixels_below_lines, :pixels_inside_wrap, :right_margin, :tabs, :top_margin, :wrap_mode
    end
  end

  module Gtk
    class ToggleButton < Button
      include Accessible
      include Actionable
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.ToggleButton"
      GTYPE = "GtkToggleButton"
      FIELDS = [:active, :group].freeze
      PROPERTIES = {active: "active", group: "group"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Actionable::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :active, :group
    end
  end

  module Gtk
    class Tooltip < GtkAst::GObject::Object

      TYPE = "Gtk.Tooltip"
      GTYPE = "GtkTooltip"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class TreeExpander < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.TreeExpander"
      GTYPE = "GtkTreeExpander"
      FIELDS = [:child, :hide_expander, :indent_for_depth, :indent_for_icon, :item, :list_row].freeze
      PROPERTIES = {child: "child", hide_expander: "hide-expander", indent_for_depth: "indent-for-depth", indent_for_icon: "indent-for-icon", item: "item", list_row: "list-row"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :child, :hide_expander, :indent_for_depth, :indent_for_icon, :item, :list_row
    end
  end

  module Gtk
    class TreeListModel < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel

      TYPE = "Gtk.TreeListModel"
      GTYPE = "GtkTreeListModel"
      FIELDS = [:autoexpand, :item_type, :model, :n_items, :passthrough].freeze
      PROPERTIES = {autoexpand: "autoexpand", item_type: "item-type", model: "model", n_items: "n-items", passthrough: "passthrough"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :autoexpand, :item_type, :model, :n_items, :passthrough
    end
  end

  module Gtk
    class TreeListRow < GtkAst::GObject::Object

      TYPE = "Gtk.TreeListRow"
      GTYPE = "GtkTreeListRow"
      FIELDS = [:children, :depth, :expandable, :expanded, :item].freeze
      PROPERTIES = {children: "children", depth: "depth", expandable: "expandable", expanded: "expanded", item: "item"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :children, :depth, :expandable, :expanded, :item
    end
  end

  module Gtk
    class TreeListRowSorter < Sorter

      TYPE = "Gtk.TreeListRowSorter"
      GTYPE = "GtkTreeListRowSorter"
      FIELDS = [:sorter].freeze
      PROPERTIES = {sorter: "sorter"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :sorter
    end
  end

  module Gtk
    class TreeModelFilter < GtkAst::GObject::Object
      include TreeDragSource
      include TreeModel

      TYPE = "Gtk.TreeModelFilter"
      GTYPE = "GtkTreeModelFilter"
      FIELDS = [:child_model, :virtual_root].freeze
      PROPERTIES = {child_model: "child-model", virtual_root: "virtual-root"}.freeze
      KEYS = (superclass::KEYS + TreeDragSource::FIELDS + TreeModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :child_model, :virtual_root
    end
  end

  module Gtk
    class TreeModelSort < GtkAst::GObject::Object
      include TreeDragSource
      include TreeModel
      include TreeSortable

      TYPE = "Gtk.TreeModelSort"
      GTYPE = "GtkTreeModelSort"
      FIELDS = [:model].freeze
      PROPERTIES = {model: "model"}.freeze
      KEYS = (superclass::KEYS + TreeDragSource::FIELDS + TreeModel::FIELDS + TreeSortable::FIELDS + FIELDS).uniq.freeze

      attr_reader :model
    end
  end

  module Gtk
    class TreeSelection < GtkAst::GObject::Object

      TYPE = "Gtk.TreeSelection"
      GTYPE = "GtkTreeSelection"
      FIELDS = [:mode].freeze
      PROPERTIES = {mode: "mode"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
      MODE_DOMAIN = [:none, :single, :browse, :multiple].freeze

      attr_reader :mode
    end
  end

  module Gtk
    class TreeStore < GtkAst::GObject::Object
      include Buildable
      include TreeDragDest
      include TreeDragSource
      include TreeModel
      include TreeSortable

      TYPE = "Gtk.TreeStore"
      GTYPE = "GtkTreeStore"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + Buildable::FIELDS + TreeDragDest::FIELDS + TreeDragSource::FIELDS + TreeModel::FIELDS + TreeSortable::FIELDS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class TreeView < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Scrollable

      TYPE = "Gtk.TreeView"
      GTYPE = "GtkTreeView"
      FIELDS = [:activate_on_single_click, :enable_grid_lines, :enable_search, :enable_tree_lines, :expander_column, :fixed_height_mode, :headers_clickable, :headers_visible, :hover_expand, :hover_selection, :level_indentation, :model, :reorderable, :rubber_banding, :search_column, :show_expanders, :tooltip_column].freeze
      PROPERTIES = {activate_on_single_click: "activate-on-single-click", enable_grid_lines: "enable-grid-lines", enable_search: "enable-search", enable_tree_lines: "enable-tree-lines", expander_column: "expander-column", fixed_height_mode: "fixed-height-mode", headers_clickable: "headers-clickable", headers_visible: "headers-visible", hover_expand: "hover-expand", hover_selection: "hover-selection", level_indentation: "level-indentation", model: "model", reorderable: "reorderable", rubber_banding: "rubber-banding", search_column: "search-column", show_expanders: "show-expanders", tooltip_column: "tooltip-column"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Scrollable::FIELDS + FIELDS).uniq.freeze
      ENABLE_GRID_LINES_DOMAIN = [:none, :horizontal, :vertical, :both].freeze

      attr_reader :activate_on_single_click, :enable_grid_lines, :enable_search, :enable_tree_lines, :expander_column, :fixed_height_mode, :headers_clickable, :headers_visible, :hover_expand, :hover_selection, :level_indentation, :model, :reorderable, :rubber_banding, :search_column, :show_expanders, :tooltip_column
    end
  end

  module Gtk
    class TreeViewColumn < GtkAst::GObject::InitiallyUnowned
      include Buildable
      include CellLayout

      TYPE = "Gtk.TreeViewColumn"
      GTYPE = "GtkTreeViewColumn"
      FIELDS = [:alignment, :cell_area, :clickable, :expand, :fixed_width, :max_width, :min_width, :reorderable, :resizable, :sizing, :sort_column_id, :sort_indicator, :sort_order, :spacing, :title, :visible, :widget, :width, :x_offset].freeze
      PROPERTIES = {alignment: "alignment", cell_area: "cell-area", clickable: "clickable", expand: "expand", fixed_width: "fixed-width", max_width: "max-width", min_width: "min-width", reorderable: "reorderable", resizable: "resizable", sizing: "sizing", sort_column_id: "sort-column-id", sort_indicator: "sort-indicator", sort_order: "sort-order", spacing: "spacing", title: "title", visible: "visible", widget: "widget", width: "width", x_offset: "x-offset"}.freeze
      KEYS = (superclass::KEYS + Buildable::FIELDS + CellLayout::FIELDS + FIELDS).uniq.freeze
      SIZING_DOMAIN = [:grow_only, :autosize, :fixed].freeze
      SORT_ORDER_DOMAIN = [:ascending, :descending].freeze

      attr_reader :alignment, :cell_area, :clickable, :expand, :fixed_width, :max_width, :min_width, :reorderable, :resizable, :sizing, :sort_column_id, :sort_indicator, :sort_order, :spacing, :title, :visible, :widget, :width, :x_offset
    end
  end

  module Gtk
    class TryExpression < Expression

      TYPE = "Gtk.TryExpression"
      GTYPE = "GtkTryExpression"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class UriLauncher < GtkAst::GObject::Object

      TYPE = "Gtk.UriLauncher"
      GTYPE = "GtkUriLauncher"
      FIELDS = [:uri].freeze
      PROPERTIES = {uri: "uri"}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze

      attr_reader :uri
    end
  end

  module Gtk
    class Video < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.Video"
      GTYPE = "GtkVideo"
      FIELDS = [:autoplay, :file, :graphics_offload, :loop, :media_stream].freeze
      PROPERTIES = {autoplay: "autoplay", file: "file", graphics_offload: "graphics-offload", loop: "loop", media_stream: "media-stream"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      GRAPHICS_OFFLOAD_DOMAIN = [:enabled, :disabled].freeze

      attr_reader :autoplay, :file, :graphics_offload, :loop, :media_stream
    end
  end

  module Gtk
    class Viewport < Widget
      include Accessible
      include Buildable
      include ConstraintTarget
      include Scrollable

      TYPE = "Gtk.Viewport"
      GTYPE = "GtkViewport"
      FIELDS = [:child, :scroll_to_focus].freeze
      PROPERTIES = {child: "child", scroll_to_focus: "scroll-to-focus"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Scrollable::FIELDS + FIELDS).uniq.freeze

      attr_reader :child, :scroll_to_focus
    end
  end

  module Gtk
    class VolumeButton < ScaleButton
      include Accessible
      include AccessibleRange
      include Buildable
      include ConstraintTarget
      include Orientable

      TYPE = "Gtk.VolumeButton"
      GTYPE = "GtkVolumeButton"
      FIELDS = [:use_symbolic].freeze
      PROPERTIES = {use_symbolic: "use-symbolic"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + AccessibleRange::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + Orientable::FIELDS + FIELDS).uniq.freeze

      attr_reader :use_symbolic
    end
  end

  module Gtk
    class WidgetPaintable < GtkAst::GObject::Object
      include GtkAst::Gdk::Paintable

      TYPE = "Gtk.WidgetPaintable"
      GTYPE = "GtkWidgetPaintable"
      FIELDS = [:widget].freeze
      PROPERTIES = {widget: "widget"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gdk::Paintable::FIELDS + FIELDS).uniq.freeze

      attr_reader :widget
    end
  end

  module Gtk
    class WindowControls < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.WindowControls"
      GTYPE = "GtkWindowControls"
      FIELDS = [:decoration_layout, :empty, :side, :use_native_controls].freeze
      PROPERTIES = {decoration_layout: "decoration-layout", empty: "empty", side: "side", use_native_controls: "use-native-controls"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze
      SIDE_DOMAIN = [:start, :end].freeze

      attr_reader :decoration_layout, :empty, :side, :use_native_controls
    end
  end

  module Gtk
    class WindowGroup < GtkAst::GObject::Object

      TYPE = "Gtk.WindowGroup"
      GTYPE = "GtkWindowGroup"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Gtk
    class WindowHandle < Widget
      include Accessible
      include Buildable
      include ConstraintTarget

      TYPE = "Gtk.WindowHandle"
      GTYPE = "GtkWindowHandle"
      FIELDS = [:child].freeze
      PROPERTIES = {child: "child"}.freeze
      KEYS = (superclass::KEYS + Accessible::FIELDS + Buildable::FIELDS + ConstraintTarget::FIELDS + FIELDS).uniq.freeze

      attr_reader :child
    end
  end

  module Pango
    class Context < GtkAst::GObject::Object

      TYPE = "Pango.Context"
      GTYPE = "PangoContext"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Pango
    class Coverage < GtkAst::GObject::Object

      TYPE = "Pango.Coverage"
      GTYPE = "PangoCoverage"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Pango
    class FontFace < GtkAst::GObject::Object

      TYPE = "Pango.FontFace"
      GTYPE = "PangoFontFace"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Pango
    class FontFamily < GtkAst::GObject::Object
      include GtkAst::Gio::ListModel

      TYPE = "Pango.FontFamily"
      GTYPE = "PangoFontFamily"
      FIELDS = [:is_monospace, :is_variable, :item_type, :n_items, :name].freeze
      PROPERTIES = {is_monospace: "is-monospace", is_variable: "is-variable", item_type: "item-type", n_items: "n-items", name: "name"}.freeze
      KEYS = (superclass::KEYS + GtkAst::Gio::ListModel::FIELDS + FIELDS).uniq.freeze

      attr_reader :is_monospace, :is_variable, :item_type, :n_items, :name
    end
  end

  module Pango
    class Fontset < GtkAst::GObject::Object

      TYPE = "Pango.Fontset"
      GTYPE = "PangoFontset"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Pango
    class FontsetSimple < Fontset

      TYPE = "Pango.FontsetSimple"
      GTYPE = "PangoFontsetSimple"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Pango
    class Layout < GtkAst::GObject::Object

      TYPE = "Pango.Layout"
      GTYPE = "PangoLayout"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  module Pango
    class Renderer < GtkAst::GObject::Object

      TYPE = "Pango.Renderer"
      GTYPE = "PangoRenderer"
      FIELDS = [].freeze
      PROPERTIES = {}.freeze
      KEYS = (superclass::KEYS + FIELDS).uniq.freeze
    end
  end

  BY_TYPE = {
    "GObject.Object" => GObject::Object,
    "GObject.InitiallyUnowned" => GObject::InitiallyUnowned,
    "Gtk.Accessible" => Gtk::Accessible,
    "Gtk.Buildable" => Gtk::Buildable,
    "Gtk.ConstraintTarget" => Gtk::ConstraintTarget,
    "Gtk.Widget" => Gtk::Widget,
    "Adw.Swipeable" => Adw::Swipeable,
    "GObject.TypePlugin" => GObject::TypePlugin,
    "Gdk.Device" => Gdk::Device,
    "Gdk.DevicePad" => Gdk::DevicePad,
    "Gdk.Surface" => Gdk::Surface,
    "Gdk.DragSurface" => Gdk::DragSurface,
    "Gdk.Paintable" => Gdk::Paintable,
    "Gdk.Popup" => Gdk::Popup,
    "Gdk.Toplevel" => Gdk::Toplevel,
    "Gio.Action" => Gio::Action,
    "Gio.ActionGroup" => Gio::ActionGroup,
    "Gio.ActionMap" => Gio::ActionMap,
    "Gio.AppInfo" => Gio::AppInfo,
    "Gio.AsyncInitable" => Gio::AsyncInitable,
    "Gio.AsyncResult" => Gio::AsyncResult,
    "Gio.Converter" => Gio::Converter,
    "Gio.DBusInterface" => Gio::DBusInterface,
    "Gio.DBusObject" => Gio::DBusObject,
    "Gio.DBusObjectManager" => Gio::DBusObjectManager,
    "Gio.DatagramBased" => Gio::DatagramBased,
    "Gio.Initable" => Gio::Initable,
    "Gio.DebugController" => Gio::DebugController,
    "Gio.Drive" => Gio::Drive,
    "Gio.DtlsConnection" => Gio::DtlsConnection,
    "Gio.DtlsClientConnection" => Gio::DtlsClientConnection,
    "Gio.DtlsServerConnection" => Gio::DtlsServerConnection,
    "Gio.File" => Gio::File,
    "Gio.Icon" => Gio::Icon,
    "Gio.ListModel" => Gio::ListModel,
    "Gio.LoadableIcon" => Gio::LoadableIcon,
    "Gio.MemoryMonitor" => Gio::MemoryMonitor,
    "Gio.Mount" => Gio::Mount,
    "Gio.NetworkMonitor" => Gio::NetworkMonitor,
    "Gio.InputStream" => Gio::InputStream,
    "Gio.PollableInputStream" => Gio::PollableInputStream,
    "Gio.OutputStream" => Gio::OutputStream,
    "Gio.PollableOutputStream" => Gio::PollableOutputStream,
    "Gio.PowerProfileMonitor" => Gio::PowerProfileMonitor,
    "Gio.Proxy" => Gio::Proxy,
    "Gio.ProxyResolver" => Gio::ProxyResolver,
    "Gio.RemoteActionGroup" => Gio::RemoteActionGroup,
    "Gio.Seekable" => Gio::Seekable,
    "Gio.SocketConnectable" => Gio::SocketConnectable,
    "Gio.TlsBackend" => Gio::TlsBackend,
    "Gio.IOStream" => Gio::IOStream,
    "Gio.TlsConnection" => Gio::TlsConnection,
    "Gio.TlsClientConnection" => Gio::TlsClientConnection,
    "Gio.TlsDatabase" => Gio::TlsDatabase,
    "Gio.TlsFileDatabase" => Gio::TlsFileDatabase,
    "Gio.TlsServerConnection" => Gio::TlsServerConnection,
    "Gio.Volume" => Gio::Volume,
    "Gtk.AccessibleHypertext" => Gtk::AccessibleHypertext,
    "Gtk.AccessibleRange" => Gtk::AccessibleRange,
    "Gtk.AccessibleText" => Gtk::AccessibleText,
    "Gtk.Actionable" => Gtk::Actionable,
    "Gtk.AppChooser" => Gtk::AppChooser,
    "Gtk.BuilderScope" => Gtk::BuilderScope,
    "Gtk.CellEditable" => Gtk::CellEditable,
    "Gtk.CellLayout" => Gtk::CellLayout,
    "Gtk.ColorChooser" => Gtk::ColorChooser,
    "Gtk.Editable" => Gtk::Editable,
    "Gtk.FileChooser" => Gtk::FileChooser,
    "Gtk.FontChooser" => Gtk::FontChooser,
    "Gtk.Native" => Gtk::Native,
    "Gtk.Orientable" => Gtk::Orientable,
    "Gtk.PrintOperationPreview" => Gtk::PrintOperationPreview,
    "Gtk.Root" => Gtk::Root,
    "Gtk.Scrollable" => Gtk::Scrollable,
    "Gtk.SectionModel" => Gtk::SectionModel,
    "Gtk.SelectionModel" => Gtk::SelectionModel,
    "Gtk.ShortcutManager" => Gtk::ShortcutManager,
    "Gtk.StyleProvider" => Gtk::StyleProvider,
    "Gtk.SymbolicPaintable" => Gtk::SymbolicPaintable,
    "Gtk.TreeDragDest" => Gtk::TreeDragDest,
    "Gtk.TreeDragSource" => Gtk::TreeDragSource,
    "Gtk.TreeModel" => Gtk::TreeModel,
    "Gtk.TreeSortable" => Gtk::TreeSortable,
    "Pango.Font" => Pango::Font,
    "PangoCairo.Font" => PangoCairo::Font,
    "Pango.FontMap" => Pango::FontMap,
    "PangoCairo.FontMap" => PangoCairo::FontMap,
    "Adw.Dialog" => Adw::Dialog,
    "Adw.AboutDialog" => Adw::AboutDialog,
    "Gtk.Window" => Gtk::Window,
    "Adw.Window" => Adw::Window,
    "Adw.AboutWindow" => Adw::AboutWindow,
    "Gtk.ListBoxRow" => Gtk::ListBoxRow,
    "Adw.PreferencesRow" => Adw::PreferencesRow,
    "Adw.ActionRow" => Adw::ActionRow,
    "Adw.AlertDialog" => Adw::AlertDialog,
    "Adw.Animation" => Adw::Animation,
    "Adw.AnimationTarget" => Adw::AnimationTarget,
    "Gio.Application" => Gio::Application,
    "Gtk.Application" => Gtk::Application,
    "Adw.Application" => Adw::Application,
    "Gtk.ApplicationWindow" => Gtk::ApplicationWindow,
    "Adw.ApplicationWindow" => Adw::ApplicationWindow,
    "Adw.Avatar" => Adw::Avatar,
    "Adw.Banner" => Adw::Banner,
    "Adw.Bin" => Adw::Bin,
    "Adw.BottomSheet" => Adw::BottomSheet,
    "Adw.Breakpoint" => Adw::Breakpoint,
    "Adw.BreakpointBin" => Adw::BreakpointBin,
    "Adw.ButtonContent" => Adw::ButtonContent,
    "Adw.ButtonRow" => Adw::ButtonRow,
    "Adw.CallbackAnimationTarget" => Adw::CallbackAnimationTarget,
    "Adw.Carousel" => Adw::Carousel,
    "Adw.CarouselIndicatorDots" => Adw::CarouselIndicatorDots,
    "Adw.CarouselIndicatorLines" => Adw::CarouselIndicatorLines,
    "Adw.Clamp" => Adw::Clamp,
    "Gtk.LayoutManager" => Gtk::LayoutManager,
    "Adw.ClampLayout" => Adw::ClampLayout,
    "Adw.ClampScrollable" => Adw::ClampScrollable,
    "Adw.ComboRow" => Adw::ComboRow,
    "Adw.EntryRow" => Adw::EntryRow,
    "Adw.EnumListItem" => Adw::EnumListItem,
    "Adw.EnumListModel" => Adw::EnumListModel,
    "Adw.ExpanderRow" => Adw::ExpanderRow,
    "Adw.Flap" => Adw::Flap,
    "Adw.HeaderBar" => Adw::HeaderBar,
    "Adw.InlineViewSwitcher" => Adw::InlineViewSwitcher,
    "Adw.Layout" => Adw::Layout,
    "Adw.LayoutSlot" => Adw::LayoutSlot,
    "Adw.Leaflet" => Adw::Leaflet,
    "Adw.LeafletPage" => Adw::LeafletPage,
    "Adw.MessageDialog" => Adw::MessageDialog,
    "Adw.MultiLayoutView" => Adw::MultiLayoutView,
    "Adw.NavigationPage" => Adw::NavigationPage,
    "Adw.NavigationSplitView" => Adw::NavigationSplitView,
    "Adw.NavigationView" => Adw::NavigationView,
    "Adw.NoneAnimationTarget" => Adw::NoneAnimationTarget,
    "Adw.OverlaySplitView" => Adw::OverlaySplitView,
    "Adw.PasswordEntryRow" => Adw::PasswordEntryRow,
    "Adw.PreferencesDialog" => Adw::PreferencesDialog,
    "Adw.PreferencesGroup" => Adw::PreferencesGroup,
    "Adw.PreferencesPage" => Adw::PreferencesPage,
    "Adw.PreferencesWindow" => Adw::PreferencesWindow,
    "Adw.PropertyAnimationTarget" => Adw::PropertyAnimationTarget,
    "Adw.ShortcutLabel" => Adw::ShortcutLabel,
    "Adw.ShortcutsDialog" => Adw::ShortcutsDialog,
    "Adw.ShortcutsItem" => Adw::ShortcutsItem,
    "Adw.ShortcutsSection" => Adw::ShortcutsSection,
    "Adw.Sidebar" => Adw::Sidebar,
    "Adw.SidebarItem" => Adw::SidebarItem,
    "Adw.SidebarSection" => Adw::SidebarSection,
    "Adw.SpinRow" => Adw::SpinRow,
    "Adw.Spinner" => Adw::Spinner,
    "Adw.SpinnerPaintable" => Adw::SpinnerPaintable,
    "Adw.SplitButton" => Adw::SplitButton,
    "Adw.SpringAnimation" => Adw::SpringAnimation,
    "Adw.Squeezer" => Adw::Squeezer,
    "Adw.SqueezerPage" => Adw::SqueezerPage,
    "Adw.StatusPage" => Adw::StatusPage,
    "Adw.StyleManager" => Adw::StyleManager,
    "Adw.SwipeTracker" => Adw::SwipeTracker,
    "Adw.SwitchRow" => Adw::SwitchRow,
    "Adw.TabBar" => Adw::TabBar,
    "Adw.TabButton" => Adw::TabButton,
    "Adw.TabOverview" => Adw::TabOverview,
    "Adw.TabPage" => Adw::TabPage,
    "Adw.TabView" => Adw::TabView,
    "Adw.TimedAnimation" => Adw::TimedAnimation,
    "Adw.Toast" => Adw::Toast,
    "Adw.ToastOverlay" => Adw::ToastOverlay,
    "Adw.Toggle" => Adw::Toggle,
    "Adw.ToggleGroup" => Adw::ToggleGroup,
    "Adw.ToolbarView" => Adw::ToolbarView,
    "Adw.ViewStack" => Adw::ViewStack,
    "Adw.ViewStackPage" => Adw::ViewStackPage,
    "Adw.ViewStackPages" => Adw::ViewStackPages,
    "Adw.ViewSwitcher" => Adw::ViewSwitcher,
    "Adw.ViewSwitcherBar" => Adw::ViewSwitcherBar,
    "Adw.ViewSwitcherSidebar" => Adw::ViewSwitcherSidebar,
    "Adw.ViewSwitcherTitle" => Adw::ViewSwitcherTitle,
    "Adw.WindowTitle" => Adw::WindowTitle,
    "Adw.WrapBox" => Adw::WrapBox,
    "Adw.WrapLayout" => Adw::WrapLayout,
    "GObject.Binding" => GObject::Binding,
    "GObject.BindingGroup" => GObject::BindingGroup,
    "GObject.ParamSpec" => GObject::ParamSpec,
    "GObject.ParamSpecBoolean" => GObject::ParamSpecBoolean,
    "GObject.ParamSpecBoxed" => GObject::ParamSpecBoxed,
    "GObject.ParamSpecChar" => GObject::ParamSpecChar,
    "GObject.ParamSpecDouble" => GObject::ParamSpecDouble,
    "GObject.ParamSpecEnum" => GObject::ParamSpecEnum,
    "GObject.ParamSpecFlags" => GObject::ParamSpecFlags,
    "GObject.ParamSpecFloat" => GObject::ParamSpecFloat,
    "GObject.ParamSpecGType" => GObject::ParamSpecGType,
    "GObject.ParamSpecInt" => GObject::ParamSpecInt,
    "GObject.ParamSpecInt64" => GObject::ParamSpecInt64,
    "GObject.ParamSpecLong" => GObject::ParamSpecLong,
    "GObject.ParamSpecObject" => GObject::ParamSpecObject,
    "GObject.ParamSpecOverride" => GObject::ParamSpecOverride,
    "GObject.ParamSpecParam" => GObject::ParamSpecParam,
    "GObject.ParamSpecPointer" => GObject::ParamSpecPointer,
    "GObject.ParamSpecString" => GObject::ParamSpecString,
    "GObject.ParamSpecUChar" => GObject::ParamSpecUChar,
    "GObject.ParamSpecUInt" => GObject::ParamSpecUInt,
    "GObject.ParamSpecUInt64" => GObject::ParamSpecUInt64,
    "GObject.ParamSpecULong" => GObject::ParamSpecULong,
    "GObject.ParamSpecUnichar" => GObject::ParamSpecUnichar,
    "GObject.ParamSpecValueArray" => GObject::ParamSpecValueArray,
    "GObject.ParamSpecVariant" => GObject::ParamSpecVariant,
    "GObject.SignalGroup" => GObject::SignalGroup,
    "GObject.TypeModule" => GObject::TypeModule,
    "Gio.AppLaunchContext" => Gio::AppLaunchContext,
    "Gdk.AppLaunchContext" => Gdk::AppLaunchContext,
    "Gdk.Event" => Gdk::Event,
    "Gdk.ButtonEvent" => Gdk::ButtonEvent,
    "Gdk.DrawContext" => Gdk::DrawContext,
    "Gdk.CairoContext" => Gdk::CairoContext,
    "Gdk.CicpParams" => Gdk::CicpParams,
    "Gdk.Clipboard" => Gdk::Clipboard,
    "Gdk.ContentDeserializer" => Gdk::ContentDeserializer,
    "Gdk.ContentProvider" => Gdk::ContentProvider,
    "Gdk.ContentSerializer" => Gdk::ContentSerializer,
    "Gdk.CrossingEvent" => Gdk::CrossingEvent,
    "Gdk.Cursor" => Gdk::Cursor,
    "Gdk.DNDEvent" => Gdk::DNDEvent,
    "Gdk.DeleteEvent" => Gdk::DeleteEvent,
    "Gdk.DeviceTool" => Gdk::DeviceTool,
    "Gdk.Display" => Gdk::Display,
    "Gdk.DisplayManager" => Gdk::DisplayManager,
    "Gdk.Texture" => Gdk::Texture,
    "Gdk.DmabufTexture" => Gdk::DmabufTexture,
    "Gdk.DmabufTextureBuilder" => Gdk::DmabufTextureBuilder,
    "Gdk.Drag" => Gdk::Drag,
    "Gdk.Drop" => Gdk::Drop,
    "Gdk.FocusEvent" => Gdk::FocusEvent,
    "Gdk.FrameClock" => Gdk::FrameClock,
    "Gdk.GLContext" => Gdk::GLContext,
    "Gdk.GLTexture" => Gdk::GLTexture,
    "Gdk.GLTextureBuilder" => Gdk::GLTextureBuilder,
    "Gdk.GrabBrokenEvent" => Gdk::GrabBrokenEvent,
    "Gdk.KeyEvent" => Gdk::KeyEvent,
    "Gdk.MemoryTexture" => Gdk::MemoryTexture,
    "Gdk.MemoryTextureBuilder" => Gdk::MemoryTextureBuilder,
    "Gdk.Monitor" => Gdk::Monitor,
    "Gdk.MotionEvent" => Gdk::MotionEvent,
    "Gdk.PadEvent" => Gdk::PadEvent,
    "Gdk.ProximityEvent" => Gdk::ProximityEvent,
    "Gdk.ScrollEvent" => Gdk::ScrollEvent,
    "Gdk.Seat" => Gdk::Seat,
    "Gdk.Snapshot" => Gdk::Snapshot,
    "Gdk.TouchEvent" => Gdk::TouchEvent,
    "Gdk.TouchpadEvent" => Gdk::TouchpadEvent,
    "Gdk.VulkanContext" => Gdk::VulkanContext,
    "GdkPixbuf.Pixbuf" => GdkPixbuf::Pixbuf,
    "GdkPixbuf.PixbufAnimation" => GdkPixbuf::PixbufAnimation,
    "GdkPixbuf.PixbufAnimationIter" => GdkPixbuf::PixbufAnimationIter,
    "GdkPixbuf.PixbufLoader" => GdkPixbuf::PixbufLoader,
    "GdkPixbuf.PixbufNonAnim" => GdkPixbuf::PixbufNonAnim,
    "GdkPixbuf.PixbufSimpleAnim" => GdkPixbuf::PixbufSimpleAnim,
    "GdkPixbuf.PixbufSimpleAnimIter" => GdkPixbuf::PixbufSimpleAnimIter,
    "Gio.AppInfoMonitor" => Gio::AppInfoMonitor,
    "Gio.ApplicationCommandLine" => Gio::ApplicationCommandLine,
    "Gio.FilterInputStream" => Gio::FilterInputStream,
    "Gio.BufferedInputStream" => Gio::BufferedInputStream,
    "Gio.FilterOutputStream" => Gio::FilterOutputStream,
    "Gio.BufferedOutputStream" => Gio::BufferedOutputStream,
    "Gio.BytesIcon" => Gio::BytesIcon,
    "Gio.Cancellable" => Gio::Cancellable,
    "Gio.CharsetConverter" => Gio::CharsetConverter,
    "Gio.ConverterInputStream" => Gio::ConverterInputStream,
    "Gio.ConverterOutputStream" => Gio::ConverterOutputStream,
    "Gio.Credentials" => Gio::Credentials,
    "Gio.DBusActionGroup" => Gio::DBusActionGroup,
    "Gio.DBusAuthObserver" => Gio::DBusAuthObserver,
    "Gio.DBusConnection" => Gio::DBusConnection,
    "Gio.DBusInterfaceSkeleton" => Gio::DBusInterfaceSkeleton,
    "Gio.MenuModel" => Gio::MenuModel,
    "Gio.DBusMenuModel" => Gio::DBusMenuModel,
    "Gio.DBusMessage" => Gio::DBusMessage,
    "Gio.DBusMethodInvocation" => Gio::DBusMethodInvocation,
    "Gio.DBusObjectManagerClient" => Gio::DBusObjectManagerClient,
    "Gio.DBusObjectManagerServer" => Gio::DBusObjectManagerServer,
    "Gio.DBusObjectProxy" => Gio::DBusObjectProxy,
    "Gio.DBusObjectSkeleton" => Gio::DBusObjectSkeleton,
    "Gio.DBusProxy" => Gio::DBusProxy,
    "Gio.DBusServer" => Gio::DBusServer,
    "Gio.DataInputStream" => Gio::DataInputStream,
    "Gio.DataOutputStream" => Gio::DataOutputStream,
    "Gio.DebugControllerDBus" => Gio::DebugControllerDBus,
    "Gio.Emblem" => Gio::Emblem,
    "Gio.EmblemedIcon" => Gio::EmblemedIcon,
    "Gio.FileEnumerator" => Gio::FileEnumerator,
    "Gio.FileIOStream" => Gio::FileIOStream,
    "Gio.FileIcon" => Gio::FileIcon,
    "Gio.FileInfo" => Gio::FileInfo,
    "Gio.FileInputStream" => Gio::FileInputStream,
    "Gio.FileMonitor" => Gio::FileMonitor,
    "Gio.FileOutputStream" => Gio::FileOutputStream,
    "Gio.FilenameCompleter" => Gio::FilenameCompleter,
    "Gio.IOModule" => Gio::IOModule,
    "Gio.SocketControlMessage" => Gio::SocketControlMessage,
    "Gio.IPTosMessage" => Gio::IPTosMessage,
    "Gio.IPv6TclassMessage" => Gio::IPv6TclassMessage,
    "Gio.InetAddress" => Gio::InetAddress,
    "Gio.InetAddressMask" => Gio::InetAddressMask,
    "Gio.SocketAddress" => Gio::SocketAddress,
    "Gio.InetSocketAddress" => Gio::InetSocketAddress,
    "Gio.ListStore" => Gio::ListStore,
    "Gio.MemoryInputStream" => Gio::MemoryInputStream,
    "Gio.MemoryOutputStream" => Gio::MemoryOutputStream,
    "Gio.Menu" => Gio::Menu,
    "Gio.MenuAttributeIter" => Gio::MenuAttributeIter,
    "Gio.MenuItem" => Gio::MenuItem,
    "Gio.MenuLinkIter" => Gio::MenuLinkIter,
    "Gio.MountOperation" => Gio::MountOperation,
    "Gio.NativeSocketAddress" => Gio::NativeSocketAddress,
    "Gio.VolumeMonitor" => Gio::VolumeMonitor,
    "Gio.NativeVolumeMonitor" => Gio::NativeVolumeMonitor,
    "Gio.NetworkAddress" => Gio::NetworkAddress,
    "Gio.NetworkService" => Gio::NetworkService,
    "Gio.Notification" => Gio::Notification,
    "Gio.Permission" => Gio::Permission,
    "Gio.PropertyAction" => Gio::PropertyAction,
    "Gio.ProxyAddress" => Gio::ProxyAddress,
    "Gio.SocketAddressEnumerator" => Gio::SocketAddressEnumerator,
    "Gio.ProxyAddressEnumerator" => Gio::ProxyAddressEnumerator,
    "Gio.Resolver" => Gio::Resolver,
    "Gio.Settings" => Gio::Settings,
    "Gio.SettingsBackend" => Gio::SettingsBackend,
    "Gio.SimpleAction" => Gio::SimpleAction,
    "Gio.SimpleActionGroup" => Gio::SimpleActionGroup,
    "Gio.SimpleAsyncResult" => Gio::SimpleAsyncResult,
    "Gio.SimpleIOStream" => Gio::SimpleIOStream,
    "Gio.SimplePermission" => Gio::SimplePermission,
    "Gio.SimpleProxyResolver" => Gio::SimpleProxyResolver,
    "Gio.Socket" => Gio::Socket,
    "Gio.SocketClient" => Gio::SocketClient,
    "Gio.SocketConnection" => Gio::SocketConnection,
    "Gio.SocketListener" => Gio::SocketListener,
    "Gio.SocketService" => Gio::SocketService,
    "Gio.Subprocess" => Gio::Subprocess,
    "Gio.SubprocessLauncher" => Gio::SubprocessLauncher,
    "Gio.Task" => Gio::Task,
    "Gio.TcpConnection" => Gio::TcpConnection,
    "Gio.TcpWrapperConnection" => Gio::TcpWrapperConnection,
    "Gio.TestDBus" => Gio::TestDBus,
    "Gio.ThemedIcon" => Gio::ThemedIcon,
    "Gio.ThreadedResolver" => Gio::ThreadedResolver,
    "Gio.ThreadedSocketService" => Gio::ThreadedSocketService,
    "Gio.TlsCertificate" => Gio::TlsCertificate,
    "Gio.TlsInteraction" => Gio::TlsInteraction,
    "Gio.TlsPassword" => Gio::TlsPassword,
    "Gio.UnixConnection" => Gio::UnixConnection,
    "Gio.UnixCredentialsMessage" => Gio::UnixCredentialsMessage,
    "Gio.UnixFDList" => Gio::UnixFDList,
    "Gio.UnixSocketAddress" => Gio::UnixSocketAddress,
    "Gio.Vfs" => Gio::Vfs,
    "Gio.ZlibCompressor" => Gio::ZlibCompressor,
    "Gio.ZlibDecompressor" => Gio::ZlibDecompressor,
    "Gsk.RenderNode" => Gsk::RenderNode,
    "Gsk.BlendNode" => Gsk::BlendNode,
    "Gsk.BlurNode" => Gsk::BlurNode,
    "Gsk.BorderNode" => Gsk::BorderNode,
    "Gsk.Renderer" => Gsk::Renderer,
    "Gsk.BroadwayRenderer" => Gsk::BroadwayRenderer,
    "Gsk.CairoNode" => Gsk::CairoNode,
    "Gsk.CairoRenderer" => Gsk::CairoRenderer,
    "Gsk.ClipNode" => Gsk::ClipNode,
    "Gsk.ColorMatrixNode" => Gsk::ColorMatrixNode,
    "Gsk.ColorNode" => Gsk::ColorNode,
    "Gsk.ComponentTransferNode" => Gsk::ComponentTransferNode,
    "Gsk.CompositeNode" => Gsk::CompositeNode,
    "Gsk.ConicGradientNode" => Gsk::ConicGradientNode,
    "Gsk.ContainerNode" => Gsk::ContainerNode,
    "Gsk.CopyNode" => Gsk::CopyNode,
    "Gsk.CrossFadeNode" => Gsk::CrossFadeNode,
    "Gsk.DebugNode" => Gsk::DebugNode,
    "Gsk.FillNode" => Gsk::FillNode,
    "Gsk.GLRenderer" => Gsk::GLRenderer,
    "Gsk.GLShader" => Gsk::GLShader,
    "Gsk.GLShaderNode" => Gsk::GLShaderNode,
    "Gsk.InsetShadowNode" => Gsk::InsetShadowNode,
    "Gsk.IsolationNode" => Gsk::IsolationNode,
    "Gsk.LinearGradientNode" => Gsk::LinearGradientNode,
    "Gsk.MaskNode" => Gsk::MaskNode,
    "Gsk.NglRenderer" => Gsk::NglRenderer,
    "Gsk.OpacityNode" => Gsk::OpacityNode,
    "Gsk.OutsetShadowNode" => Gsk::OutsetShadowNode,
    "Gsk.PasteNode" => Gsk::PasteNode,
    "Gsk.RadialGradientNode" => Gsk::RadialGradientNode,
    "Gsk.RepeatNode" => Gsk::RepeatNode,
    "Gsk.RepeatingLinearGradientNode" => Gsk::RepeatingLinearGradientNode,
    "Gsk.RepeatingRadialGradientNode" => Gsk::RepeatingRadialGradientNode,
    "Gsk.RoundedClipNode" => Gsk::RoundedClipNode,
    "Gsk.ShadowNode" => Gsk::ShadowNode,
    "Gsk.StrokeNode" => Gsk::StrokeNode,
    "Gsk.SubsurfaceNode" => Gsk::SubsurfaceNode,
    "Gsk.TextNode" => Gsk::TextNode,
    "Gsk.TextureNode" => Gsk::TextureNode,
    "Gsk.TextureScaleNode" => Gsk::TextureScaleNode,
    "Gsk.TransformNode" => Gsk::TransformNode,
    "Gsk.VulkanRenderer" => Gsk::VulkanRenderer,
    "Gtk.ATContext" => Gtk::ATContext,
    "Gtk.AboutDialog" => Gtk::AboutDialog,
    "Gtk.AccessibleHyperlink" => Gtk::AccessibleHyperlink,
    "Gtk.ActionBar" => Gtk::ActionBar,
    "Gtk.ShortcutAction" => Gtk::ShortcutAction,
    "Gtk.ActivateAction" => Gtk::ActivateAction,
    "Gtk.Adjustment" => Gtk::Adjustment,
    "Gtk.AlertDialog" => Gtk::AlertDialog,
    "Gtk.ShortcutTrigger" => Gtk::ShortcutTrigger,
    "Gtk.AlternativeTrigger" => Gtk::AlternativeTrigger,
    "Gtk.Filter" => Gtk::Filter,
    "Gtk.MultiFilter" => Gtk::MultiFilter,
    "Gtk.AnyFilter" => Gtk::AnyFilter,
    "Gtk.AppChooserButton" => Gtk::AppChooserButton,
    "Gtk.Dialog" => Gtk::Dialog,
    "Gtk.AppChooserDialog" => Gtk::AppChooserDialog,
    "Gtk.AppChooserWidget" => Gtk::AppChooserWidget,
    "Gtk.AspectFrame" => Gtk::AspectFrame,
    "Gtk.Assistant" => Gtk::Assistant,
    "Gtk.AssistantPage" => Gtk::AssistantPage,
    "Gtk.BinLayout" => Gtk::BinLayout,
    "Gtk.BookmarkList" => Gtk::BookmarkList,
    "Gtk.BoolFilter" => Gtk::BoolFilter,
    "Gtk.Box" => Gtk::Box,
    "Gtk.BoxLayout" => Gtk::BoxLayout,
    "Gtk.Builder" => Gtk::Builder,
    "Gtk.BuilderCScope" => Gtk::BuilderCScope,
    "Gtk.ListItemFactory" => Gtk::ListItemFactory,
    "Gtk.BuilderListItemFactory" => Gtk::BuilderListItemFactory,
    "Gtk.Button" => Gtk::Button,
    "Gtk.Expression" => Gtk::Expression,
    "Gtk.CClosureExpression" => Gtk::CClosureExpression,
    "Gtk.Calendar" => Gtk::Calendar,
    "Gtk.CallbackAction" => Gtk::CallbackAction,
    "Gtk.CellArea" => Gtk::CellArea,
    "Gtk.CellAreaBox" => Gtk::CellAreaBox,
    "Gtk.CellAreaContext" => Gtk::CellAreaContext,
    "Gtk.CellRenderer" => Gtk::CellRenderer,
    "Gtk.CellRendererText" => Gtk::CellRendererText,
    "Gtk.CellRendererAccel" => Gtk::CellRendererAccel,
    "Gtk.CellRendererCombo" => Gtk::CellRendererCombo,
    "Gtk.CellRendererPixbuf" => Gtk::CellRendererPixbuf,
    "Gtk.CellRendererProgress" => Gtk::CellRendererProgress,
    "Gtk.CellRendererSpin" => Gtk::CellRendererSpin,
    "Gtk.CellRendererSpinner" => Gtk::CellRendererSpinner,
    "Gtk.CellRendererToggle" => Gtk::CellRendererToggle,
    "Gtk.CellView" => Gtk::CellView,
    "Gtk.CenterBox" => Gtk::CenterBox,
    "Gtk.CenterLayout" => Gtk::CenterLayout,
    "Gtk.CheckButton" => Gtk::CheckButton,
    "Gtk.ClosureExpression" => Gtk::ClosureExpression,
    "Gtk.ColorButton" => Gtk::ColorButton,
    "Gtk.ColorChooserDialog" => Gtk::ColorChooserDialog,
    "Gtk.ColorChooserWidget" => Gtk::ColorChooserWidget,
    "Gtk.ColorDialog" => Gtk::ColorDialog,
    "Gtk.ColorDialogButton" => Gtk::ColorDialogButton,
    "Gtk.ColumnView" => Gtk::ColumnView,
    "Gtk.ListItem" => Gtk::ListItem,
    "Gtk.ColumnViewCell" => Gtk::ColumnViewCell,
    "Gtk.ColumnViewColumn" => Gtk::ColumnViewColumn,
    "Gtk.ColumnViewRow" => Gtk::ColumnViewRow,
    "Gtk.Sorter" => Gtk::Sorter,
    "Gtk.ColumnViewSorter" => Gtk::ColumnViewSorter,
    "Gtk.ComboBox" => Gtk::ComboBox,
    "Gtk.ComboBoxText" => Gtk::ComboBoxText,
    "Gtk.ConstantExpression" => Gtk::ConstantExpression,
    "Gtk.Constraint" => Gtk::Constraint,
    "Gtk.ConstraintGuide" => Gtk::ConstraintGuide,
    "Gtk.ConstraintLayout" => Gtk::ConstraintLayout,
    "Gtk.LayoutChild" => Gtk::LayoutChild,
    "Gtk.ConstraintLayoutChild" => Gtk::ConstraintLayoutChild,
    "Gtk.CssProvider" => Gtk::CssProvider,
    "Gtk.CustomFilter" => Gtk::CustomFilter,
    "Gtk.CustomLayout" => Gtk::CustomLayout,
    "Gtk.CustomSorter" => Gtk::CustomSorter,
    "Gtk.DirectoryList" => Gtk::DirectoryList,
    "Gtk.DragIcon" => Gtk::DragIcon,
    "Gtk.EventController" => Gtk::EventController,
    "Gtk.Gesture" => Gtk::Gesture,
    "Gtk.GestureSingle" => Gtk::GestureSingle,
    "Gtk.DragSource" => Gtk::DragSource,
    "Gtk.DrawingArea" => Gtk::DrawingArea,
    "Gtk.DropControllerMotion" => Gtk::DropControllerMotion,
    "Gtk.DropDown" => Gtk::DropDown,
    "Gtk.DropTarget" => Gtk::DropTarget,
    "Gtk.DropTargetAsync" => Gtk::DropTargetAsync,
    "Gtk.EditableLabel" => Gtk::EditableLabel,
    "Gtk.Popover" => Gtk::Popover,
    "Gtk.EmojiChooser" => Gtk::EmojiChooser,
    "Gtk.Entry" => Gtk::Entry,
    "Gtk.EntryBuffer" => Gtk::EntryBuffer,
    "Gtk.EntryCompletion" => Gtk::EntryCompletion,
    "Gtk.EventControllerFocus" => Gtk::EventControllerFocus,
    "Gtk.EventControllerKey" => Gtk::EventControllerKey,
    "Gtk.EventControllerLegacy" => Gtk::EventControllerLegacy,
    "Gtk.EventControllerMotion" => Gtk::EventControllerMotion,
    "Gtk.EventControllerScroll" => Gtk::EventControllerScroll,
    "Gtk.EveryFilter" => Gtk::EveryFilter,
    "Gtk.Expander" => Gtk::Expander,
    "Gtk.FileChooserDialog" => Gtk::FileChooserDialog,
    "Gtk.NativeDialog" => Gtk::NativeDialog,
    "Gtk.FileChooserNative" => Gtk::FileChooserNative,
    "Gtk.FileChooserWidget" => Gtk::FileChooserWidget,
    "Gtk.FileDialog" => Gtk::FileDialog,
    "Gtk.FileFilter" => Gtk::FileFilter,
    "Gtk.FileLauncher" => Gtk::FileLauncher,
    "Gtk.FilterListModel" => Gtk::FilterListModel,
    "Gtk.Fixed" => Gtk::Fixed,
    "Gtk.FixedLayout" => Gtk::FixedLayout,
    "Gtk.FixedLayoutChild" => Gtk::FixedLayoutChild,
    "Gtk.FlattenListModel" => Gtk::FlattenListModel,
    "Gtk.FlowBox" => Gtk::FlowBox,
    "Gtk.FlowBoxChild" => Gtk::FlowBoxChild,
    "Gtk.FontButton" => Gtk::FontButton,
    "Gtk.FontChooserDialog" => Gtk::FontChooserDialog,
    "Gtk.FontChooserWidget" => Gtk::FontChooserWidget,
    "Gtk.FontDialog" => Gtk::FontDialog,
    "Gtk.FontDialogButton" => Gtk::FontDialogButton,
    "Gtk.Frame" => Gtk::Frame,
    "Gtk.GLArea" => Gtk::GLArea,
    "Gtk.GestureClick" => Gtk::GestureClick,
    "Gtk.GestureDrag" => Gtk::GestureDrag,
    "Gtk.GestureLongPress" => Gtk::GestureLongPress,
    "Gtk.GesturePan" => Gtk::GesturePan,
    "Gtk.GestureRotate" => Gtk::GestureRotate,
    "Gtk.GestureStylus" => Gtk::GestureStylus,
    "Gtk.GestureSwipe" => Gtk::GestureSwipe,
    "Gtk.GestureZoom" => Gtk::GestureZoom,
    "Gtk.GraphicsOffload" => Gtk::GraphicsOffload,
    "Gtk.Grid" => Gtk::Grid,
    "Gtk.GridLayout" => Gtk::GridLayout,
    "Gtk.GridLayoutChild" => Gtk::GridLayoutChild,
    "Gtk.ListBase" => Gtk::ListBase,
    "Gtk.GridView" => Gtk::GridView,
    "Gtk.HeaderBar" => Gtk::HeaderBar,
    "Gtk.IMContext" => Gtk::IMContext,
    "Gtk.IMContextSimple" => Gtk::IMContextSimple,
    "Gtk.IMMulticontext" => Gtk::IMMulticontext,
    "Gtk.IconPaintable" => Gtk::IconPaintable,
    "Gtk.IconTheme" => Gtk::IconTheme,
    "Gtk.IconView" => Gtk::IconView,
    "Gtk.Image" => Gtk::Image,
    "Gtk.InfoBar" => Gtk::InfoBar,
    "Gtk.Inscription" => Gtk::Inscription,
    "Gtk.KeyvalTrigger" => Gtk::KeyvalTrigger,
    "Gtk.Label" => Gtk::Label,
    "Gtk.LevelBar" => Gtk::LevelBar,
    "Gtk.LinkButton" => Gtk::LinkButton,
    "Gtk.ListBox" => Gtk::ListBox,
    "Gtk.ListHeader" => Gtk::ListHeader,
    "Gtk.ListStore" => Gtk::ListStore,
    "Gtk.ListView" => Gtk::ListView,
    "Gtk.LockButton" => Gtk::LockButton,
    "Gtk.MapListModel" => Gtk::MapListModel,
    "Gtk.MediaControls" => Gtk::MediaControls,
    "Gtk.MediaStream" => Gtk::MediaStream,
    "Gtk.MediaFile" => Gtk::MediaFile,
    "Gtk.MenuButton" => Gtk::MenuButton,
    "Gtk.MessageDialog" => Gtk::MessageDialog,
    "Gtk.MnemonicAction" => Gtk::MnemonicAction,
    "Gtk.MnemonicTrigger" => Gtk::MnemonicTrigger,
    "Gtk.MountOperation" => Gtk::MountOperation,
    "Gtk.MultiSelection" => Gtk::MultiSelection,
    "Gtk.MultiSorter" => Gtk::MultiSorter,
    "Gtk.NamedAction" => Gtk::NamedAction,
    "Gtk.NeverTrigger" => Gtk::NeverTrigger,
    "Gtk.NoSelection" => Gtk::NoSelection,
    "Gtk.Notebook" => Gtk::Notebook,
    "Gtk.NotebookPage" => Gtk::NotebookPage,
    "Gtk.NothingAction" => Gtk::NothingAction,
    "Gtk.NumericSorter" => Gtk::NumericSorter,
    "Gtk.ObjectExpression" => Gtk::ObjectExpression,
    "Gtk.Overlay" => Gtk::Overlay,
    "Gtk.OverlayLayout" => Gtk::OverlayLayout,
    "Gtk.OverlayLayoutChild" => Gtk::OverlayLayoutChild,
    "Gtk.PadController" => Gtk::PadController,
    "Gtk.PageSetup" => Gtk::PageSetup,
    "Gtk.PageSetupUnixDialog" => Gtk::PageSetupUnixDialog,
    "Gtk.Paned" => Gtk::Paned,
    "Gtk.ParamSpecExpression" => Gtk::ParamSpecExpression,
    "Gtk.PasswordEntry" => Gtk::PasswordEntry,
    "Gtk.PasswordEntryBuffer" => Gtk::PasswordEntryBuffer,
    "Gtk.Picture" => Gtk::Picture,
    "Gtk.PopoverBin" => Gtk::PopoverBin,
    "Gtk.PopoverMenu" => Gtk::PopoverMenu,
    "Gtk.PopoverMenuBar" => Gtk::PopoverMenuBar,
    "Gtk.PrintContext" => Gtk::PrintContext,
    "Gtk.PrintDialog" => Gtk::PrintDialog,
    "Gtk.PrintJob" => Gtk::PrintJob,
    "Gtk.PrintOperation" => Gtk::PrintOperation,
    "Gtk.PrintSettings" => Gtk::PrintSettings,
    "Gtk.PrintUnixDialog" => Gtk::PrintUnixDialog,
    "Gtk.Printer" => Gtk::Printer,
    "Gtk.ProgressBar" => Gtk::ProgressBar,
    "Gtk.PropertyExpression" => Gtk::PropertyExpression,
    "Gtk.Range" => Gtk::Range,
    "Gtk.RecentManager" => Gtk::RecentManager,
    "Gtk.Revealer" => Gtk::Revealer,
    "Gtk.Scale" => Gtk::Scale,
    "Gtk.ScaleButton" => Gtk::ScaleButton,
    "Gtk.Scrollbar" => Gtk::Scrollbar,
    "Gtk.ScrolledWindow" => Gtk::ScrolledWindow,
    "Gtk.SearchBar" => Gtk::SearchBar,
    "Gtk.SearchEntry" => Gtk::SearchEntry,
    "Gtk.SelectionFilterModel" => Gtk::SelectionFilterModel,
    "Gtk.Separator" => Gtk::Separator,
    "Gtk.Settings" => Gtk::Settings,
    "Gtk.Shortcut" => Gtk::Shortcut,
    "Gtk.ShortcutController" => Gtk::ShortcutController,
    "Gtk.ShortcutLabel" => Gtk::ShortcutLabel,
    "Gtk.ShortcutsGroup" => Gtk::ShortcutsGroup,
    "Gtk.ShortcutsSection" => Gtk::ShortcutsSection,
    "Gtk.ShortcutsShortcut" => Gtk::ShortcutsShortcut,
    "Gtk.ShortcutsWindow" => Gtk::ShortcutsWindow,
    "Gtk.SignalAction" => Gtk::SignalAction,
    "Gtk.SignalListItemFactory" => Gtk::SignalListItemFactory,
    "Gtk.SingleSelection" => Gtk::SingleSelection,
    "Gtk.SizeGroup" => Gtk::SizeGroup,
    "Gtk.SliceListModel" => Gtk::SliceListModel,
    "Gtk.Snapshot" => Gtk::Snapshot,
    "Gtk.SortListModel" => Gtk::SortListModel,
    "Gtk.SpinButton" => Gtk::SpinButton,
    "Gtk.Spinner" => Gtk::Spinner,
    "Gtk.Stack" => Gtk::Stack,
    "Gtk.StackPage" => Gtk::StackPage,
    "Gtk.StackSidebar" => Gtk::StackSidebar,
    "Gtk.StackSwitcher" => Gtk::StackSwitcher,
    "Gtk.Statusbar" => Gtk::Statusbar,
    "Gtk.StringFilter" => Gtk::StringFilter,
    "Gtk.StringList" => Gtk::StringList,
    "Gtk.StringObject" => Gtk::StringObject,
    "Gtk.StringSorter" => Gtk::StringSorter,
    "Gtk.StyleContext" => Gtk::StyleContext,
    "Gtk.Svg" => Gtk::Svg,
    "Gtk.Switch" => Gtk::Switch,
    "Gtk.Text" => Gtk::Text,
    "Gtk.TextBuffer" => Gtk::TextBuffer,
    "Gtk.TextChildAnchor" => Gtk::TextChildAnchor,
    "Gtk.TextMark" => Gtk::TextMark,
    "Gtk.TextTag" => Gtk::TextTag,
    "Gtk.TextTagTable" => Gtk::TextTagTable,
    "Gtk.TextView" => Gtk::TextView,
    "Gtk.ToggleButton" => Gtk::ToggleButton,
    "Gtk.Tooltip" => Gtk::Tooltip,
    "Gtk.TreeExpander" => Gtk::TreeExpander,
    "Gtk.TreeListModel" => Gtk::TreeListModel,
    "Gtk.TreeListRow" => Gtk::TreeListRow,
    "Gtk.TreeListRowSorter" => Gtk::TreeListRowSorter,
    "Gtk.TreeModelFilter" => Gtk::TreeModelFilter,
    "Gtk.TreeModelSort" => Gtk::TreeModelSort,
    "Gtk.TreeSelection" => Gtk::TreeSelection,
    "Gtk.TreeStore" => Gtk::TreeStore,
    "Gtk.TreeView" => Gtk::TreeView,
    "Gtk.TreeViewColumn" => Gtk::TreeViewColumn,
    "Gtk.TryExpression" => Gtk::TryExpression,
    "Gtk.UriLauncher" => Gtk::UriLauncher,
    "Gtk.Video" => Gtk::Video,
    "Gtk.Viewport" => Gtk::Viewport,
    "Gtk.VolumeButton" => Gtk::VolumeButton,
    "Gtk.WidgetPaintable" => Gtk::WidgetPaintable,
    "Gtk.WindowControls" => Gtk::WindowControls,
    "Gtk.WindowGroup" => Gtk::WindowGroup,
    "Gtk.WindowHandle" => Gtk::WindowHandle,
    "Pango.Context" => Pango::Context,
    "Pango.Coverage" => Pango::Coverage,
    "Pango.FontFace" => Pango::FontFace,
    "Pango.FontFamily" => Pango::FontFamily,
    "Pango.Fontset" => Pango::Fontset,
    "Pango.FontsetSimple" => Pango::FontsetSimple,
    "Pango.Layout" => Pango::Layout,
    "Pango.Renderer" => Pango::Renderer,
  }.freeze

  BY_GTYPE = {
    "GObject" => GObject::Object,
    "GInitiallyUnowned" => GObject::InitiallyUnowned,
    "GtkAccessible" => Gtk::Accessible,
    "GtkBuildable" => Gtk::Buildable,
    "GtkConstraintTarget" => Gtk::ConstraintTarget,
    "GtkWidget" => Gtk::Widget,
    "AdwSwipeable" => Adw::Swipeable,
    "GTypePlugin" => GObject::TypePlugin,
    "GdkDevice" => Gdk::Device,
    "GdkDevicePad" => Gdk::DevicePad,
    "GdkSurface" => Gdk::Surface,
    "GdkDragSurface" => Gdk::DragSurface,
    "GdkPaintable" => Gdk::Paintable,
    "GdkPopup" => Gdk::Popup,
    "GdkToplevel" => Gdk::Toplevel,
    "GAction" => Gio::Action,
    "GActionGroup" => Gio::ActionGroup,
    "GActionMap" => Gio::ActionMap,
    "GAppInfo" => Gio::AppInfo,
    "GAsyncInitable" => Gio::AsyncInitable,
    "GAsyncResult" => Gio::AsyncResult,
    "GConverter" => Gio::Converter,
    "GDBusInterface" => Gio::DBusInterface,
    "GDBusObject" => Gio::DBusObject,
    "GDBusObjectManager" => Gio::DBusObjectManager,
    "GDatagramBased" => Gio::DatagramBased,
    "GInitable" => Gio::Initable,
    "GDebugController" => Gio::DebugController,
    "GDrive" => Gio::Drive,
    "GDtlsConnection" => Gio::DtlsConnection,
    "GDtlsClientConnection" => Gio::DtlsClientConnection,
    "GDtlsServerConnection" => Gio::DtlsServerConnection,
    "GFile" => Gio::File,
    "GIcon" => Gio::Icon,
    "GListModel" => Gio::ListModel,
    "GLoadableIcon" => Gio::LoadableIcon,
    "GMemoryMonitor" => Gio::MemoryMonitor,
    "GMount" => Gio::Mount,
    "GNetworkMonitor" => Gio::NetworkMonitor,
    "GInputStream" => Gio::InputStream,
    "GPollableInputStream" => Gio::PollableInputStream,
    "GOutputStream" => Gio::OutputStream,
    "GPollableOutputStream" => Gio::PollableOutputStream,
    "GPowerProfileMonitor" => Gio::PowerProfileMonitor,
    "GProxy" => Gio::Proxy,
    "GProxyResolver" => Gio::ProxyResolver,
    "GRemoteActionGroup" => Gio::RemoteActionGroup,
    "GSeekable" => Gio::Seekable,
    "GSocketConnectable" => Gio::SocketConnectable,
    "GTlsBackend" => Gio::TlsBackend,
    "GIOStream" => Gio::IOStream,
    "GTlsConnection" => Gio::TlsConnection,
    "GTlsClientConnection" => Gio::TlsClientConnection,
    "GTlsDatabase" => Gio::TlsDatabase,
    "GTlsFileDatabase" => Gio::TlsFileDatabase,
    "GTlsServerConnection" => Gio::TlsServerConnection,
    "GVolume" => Gio::Volume,
    "GtkAccessibleHypertext" => Gtk::AccessibleHypertext,
    "GtkAccessibleRange" => Gtk::AccessibleRange,
    "GtkAccessibleText" => Gtk::AccessibleText,
    "GtkActionable" => Gtk::Actionable,
    "GtkAppChooser" => Gtk::AppChooser,
    "GtkBuilderScope" => Gtk::BuilderScope,
    "GtkCellEditable" => Gtk::CellEditable,
    "GtkCellLayout" => Gtk::CellLayout,
    "GtkColorChooser" => Gtk::ColorChooser,
    "GtkEditable" => Gtk::Editable,
    "GtkFileChooser" => Gtk::FileChooser,
    "GtkFontChooser" => Gtk::FontChooser,
    "GtkNative" => Gtk::Native,
    "GtkOrientable" => Gtk::Orientable,
    "GtkPrintOperationPreview" => Gtk::PrintOperationPreview,
    "GtkRoot" => Gtk::Root,
    "GtkScrollable" => Gtk::Scrollable,
    "GtkSectionModel" => Gtk::SectionModel,
    "GtkSelectionModel" => Gtk::SelectionModel,
    "GtkShortcutManager" => Gtk::ShortcutManager,
    "GtkStyleProvider" => Gtk::StyleProvider,
    "GtkSymbolicPaintable" => Gtk::SymbolicPaintable,
    "GtkTreeDragDest" => Gtk::TreeDragDest,
    "GtkTreeDragSource" => Gtk::TreeDragSource,
    "GtkTreeModel" => Gtk::TreeModel,
    "GtkTreeSortable" => Gtk::TreeSortable,
    "PangoFont" => Pango::Font,
    "PangoCairoFont" => PangoCairo::Font,
    "PangoFontMap" => Pango::FontMap,
    "PangoCairoFontMap" => PangoCairo::FontMap,
    "AdwDialog" => Adw::Dialog,
    "AdwAboutDialog" => Adw::AboutDialog,
    "GtkWindow" => Gtk::Window,
    "AdwWindow" => Adw::Window,
    "AdwAboutWindow" => Adw::AboutWindow,
    "GtkListBoxRow" => Gtk::ListBoxRow,
    "AdwPreferencesRow" => Adw::PreferencesRow,
    "AdwActionRow" => Adw::ActionRow,
    "AdwAlertDialog" => Adw::AlertDialog,
    "AdwAnimation" => Adw::Animation,
    "AdwAnimationTarget" => Adw::AnimationTarget,
    "GApplication" => Gio::Application,
    "GtkApplication" => Gtk::Application,
    "AdwApplication" => Adw::Application,
    "GtkApplicationWindow" => Gtk::ApplicationWindow,
    "AdwApplicationWindow" => Adw::ApplicationWindow,
    "AdwAvatar" => Adw::Avatar,
    "AdwBanner" => Adw::Banner,
    "AdwBin" => Adw::Bin,
    "AdwBottomSheet" => Adw::BottomSheet,
    "AdwBreakpoint" => Adw::Breakpoint,
    "AdwBreakpointBin" => Adw::BreakpointBin,
    "AdwButtonContent" => Adw::ButtonContent,
    "AdwButtonRow" => Adw::ButtonRow,
    "AdwCallbackAnimationTarget" => Adw::CallbackAnimationTarget,
    "AdwCarousel" => Adw::Carousel,
    "AdwCarouselIndicatorDots" => Adw::CarouselIndicatorDots,
    "AdwCarouselIndicatorLines" => Adw::CarouselIndicatorLines,
    "AdwClamp" => Adw::Clamp,
    "GtkLayoutManager" => Gtk::LayoutManager,
    "AdwClampLayout" => Adw::ClampLayout,
    "AdwClampScrollable" => Adw::ClampScrollable,
    "AdwComboRow" => Adw::ComboRow,
    "AdwEntryRow" => Adw::EntryRow,
    "AdwEnumListItem" => Adw::EnumListItem,
    "AdwEnumListModel" => Adw::EnumListModel,
    "AdwExpanderRow" => Adw::ExpanderRow,
    "AdwFlap" => Adw::Flap,
    "AdwHeaderBar" => Adw::HeaderBar,
    "AdwInlineViewSwitcher" => Adw::InlineViewSwitcher,
    "AdwLayout" => Adw::Layout,
    "AdwLayoutSlot" => Adw::LayoutSlot,
    "AdwLeaflet" => Adw::Leaflet,
    "AdwLeafletPage" => Adw::LeafletPage,
    "AdwMessageDialog" => Adw::MessageDialog,
    "AdwMultiLayoutView" => Adw::MultiLayoutView,
    "AdwNavigationPage" => Adw::NavigationPage,
    "AdwNavigationSplitView" => Adw::NavigationSplitView,
    "AdwNavigationView" => Adw::NavigationView,
    "AdwNoneAnimationTarget" => Adw::NoneAnimationTarget,
    "AdwOverlaySplitView" => Adw::OverlaySplitView,
    "AdwPasswordEntryRow" => Adw::PasswordEntryRow,
    "AdwPreferencesDialog" => Adw::PreferencesDialog,
    "AdwPreferencesGroup" => Adw::PreferencesGroup,
    "AdwPreferencesPage" => Adw::PreferencesPage,
    "AdwPreferencesWindow" => Adw::PreferencesWindow,
    "AdwPropertyAnimationTarget" => Adw::PropertyAnimationTarget,
    "AdwShortcutLabel" => Adw::ShortcutLabel,
    "AdwShortcutsDialog" => Adw::ShortcutsDialog,
    "AdwShortcutsItem" => Adw::ShortcutsItem,
    "AdwShortcutsSection" => Adw::ShortcutsSection,
    "AdwSidebar" => Adw::Sidebar,
    "AdwSidebarItem" => Adw::SidebarItem,
    "AdwSidebarSection" => Adw::SidebarSection,
    "AdwSpinRow" => Adw::SpinRow,
    "AdwSpinner" => Adw::Spinner,
    "AdwSpinnerPaintable" => Adw::SpinnerPaintable,
    "AdwSplitButton" => Adw::SplitButton,
    "AdwSpringAnimation" => Adw::SpringAnimation,
    "AdwSqueezer" => Adw::Squeezer,
    "AdwSqueezerPage" => Adw::SqueezerPage,
    "AdwStatusPage" => Adw::StatusPage,
    "AdwStyleManager" => Adw::StyleManager,
    "AdwSwipeTracker" => Adw::SwipeTracker,
    "AdwSwitchRow" => Adw::SwitchRow,
    "AdwTabBar" => Adw::TabBar,
    "AdwTabButton" => Adw::TabButton,
    "AdwTabOverview" => Adw::TabOverview,
    "AdwTabPage" => Adw::TabPage,
    "AdwTabView" => Adw::TabView,
    "AdwTimedAnimation" => Adw::TimedAnimation,
    "AdwToast" => Adw::Toast,
    "AdwToastOverlay" => Adw::ToastOverlay,
    "AdwToggle" => Adw::Toggle,
    "AdwToggleGroup" => Adw::ToggleGroup,
    "AdwToolbarView" => Adw::ToolbarView,
    "AdwViewStack" => Adw::ViewStack,
    "AdwViewStackPage" => Adw::ViewStackPage,
    "AdwViewStackPages" => Adw::ViewStackPages,
    "AdwViewSwitcher" => Adw::ViewSwitcher,
    "AdwViewSwitcherBar" => Adw::ViewSwitcherBar,
    "AdwViewSwitcherSidebar" => Adw::ViewSwitcherSidebar,
    "AdwViewSwitcherTitle" => Adw::ViewSwitcherTitle,
    "AdwWindowTitle" => Adw::WindowTitle,
    "AdwWrapBox" => Adw::WrapBox,
    "AdwWrapLayout" => Adw::WrapLayout,
    "GBinding" => GObject::Binding,
    "GBindingGroup" => GObject::BindingGroup,
    "GParam" => GObject::ParamSpec,
    "GParamBoolean" => GObject::ParamSpecBoolean,
    "GParamBoxed" => GObject::ParamSpecBoxed,
    "GParamChar" => GObject::ParamSpecChar,
    "GParamDouble" => GObject::ParamSpecDouble,
    "GParamEnum" => GObject::ParamSpecEnum,
    "GParamFlags" => GObject::ParamSpecFlags,
    "GParamFloat" => GObject::ParamSpecFloat,
    "GParamGType" => GObject::ParamSpecGType,
    "GParamInt" => GObject::ParamSpecInt,
    "GParamInt64" => GObject::ParamSpecInt64,
    "GParamLong" => GObject::ParamSpecLong,
    "GParamObject" => GObject::ParamSpecObject,
    "GParamOverride" => GObject::ParamSpecOverride,
    "GParamParam" => GObject::ParamSpecParam,
    "GParamPointer" => GObject::ParamSpecPointer,
    "GParamString" => GObject::ParamSpecString,
    "GParamUChar" => GObject::ParamSpecUChar,
    "GParamUInt" => GObject::ParamSpecUInt,
    "GParamUInt64" => GObject::ParamSpecUInt64,
    "GParamULong" => GObject::ParamSpecULong,
    "GParamUnichar" => GObject::ParamSpecUnichar,
    "GParamValueArray" => GObject::ParamSpecValueArray,
    "GParamVariant" => GObject::ParamSpecVariant,
    "GSignalGroup" => GObject::SignalGroup,
    "GTypeModule" => GObject::TypeModule,
    "GAppLaunchContext" => Gio::AppLaunchContext,
    "GdkAppLaunchContext" => Gdk::AppLaunchContext,
    "GdkEvent" => Gdk::Event,
    "GdkButtonEvent" => Gdk::ButtonEvent,
    "GdkDrawContext" => Gdk::DrawContext,
    "GdkCairoContext" => Gdk::CairoContext,
    "GdkCicpParams" => Gdk::CicpParams,
    "GdkClipboard" => Gdk::Clipboard,
    "GdkContentDeserializer" => Gdk::ContentDeserializer,
    "GdkContentProvider" => Gdk::ContentProvider,
    "GdkContentSerializer" => Gdk::ContentSerializer,
    "GdkCrossingEvent" => Gdk::CrossingEvent,
    "GdkCursor" => Gdk::Cursor,
    "GdkDNDEvent" => Gdk::DNDEvent,
    "GdkDeleteEvent" => Gdk::DeleteEvent,
    "GdkDeviceTool" => Gdk::DeviceTool,
    "GdkDisplay" => Gdk::Display,
    "GdkDisplayManager" => Gdk::DisplayManager,
    "GdkTexture" => Gdk::Texture,
    "GdkDmabufTexture" => Gdk::DmabufTexture,
    "GdkDmabufTextureBuilder" => Gdk::DmabufTextureBuilder,
    "GdkDrag" => Gdk::Drag,
    "GdkDrop" => Gdk::Drop,
    "GdkFocusEvent" => Gdk::FocusEvent,
    "GdkFrameClock" => Gdk::FrameClock,
    "GdkGLContext" => Gdk::GLContext,
    "GdkGLTexture" => Gdk::GLTexture,
    "GdkGLTextureBuilder" => Gdk::GLTextureBuilder,
    "GdkGrabBrokenEvent" => Gdk::GrabBrokenEvent,
    "GdkKeyEvent" => Gdk::KeyEvent,
    "GdkMemoryTexture" => Gdk::MemoryTexture,
    "GdkMemoryTextureBuilder" => Gdk::MemoryTextureBuilder,
    "GdkMonitor" => Gdk::Monitor,
    "GdkMotionEvent" => Gdk::MotionEvent,
    "GdkPadEvent" => Gdk::PadEvent,
    "GdkProximityEvent" => Gdk::ProximityEvent,
    "GdkScrollEvent" => Gdk::ScrollEvent,
    "GdkSeat" => Gdk::Seat,
    "GdkSnapshot" => Gdk::Snapshot,
    "GdkTouchEvent" => Gdk::TouchEvent,
    "GdkTouchpadEvent" => Gdk::TouchpadEvent,
    "GdkVulkanContext" => Gdk::VulkanContext,
    "GdkPixbuf" => GdkPixbuf::Pixbuf,
    "GdkPixbufAnimation" => GdkPixbuf::PixbufAnimation,
    "GdkPixbufAnimationIter" => GdkPixbuf::PixbufAnimationIter,
    "GdkPixbufLoader" => GdkPixbuf::PixbufLoader,
    "GdkPixbufNonAnim" => GdkPixbuf::PixbufNonAnim,
    "GdkPixbufSimpleAnim" => GdkPixbuf::PixbufSimpleAnim,
    "GdkPixbufSimpleAnimIter" => GdkPixbuf::PixbufSimpleAnimIter,
    "GAppInfoMonitor" => Gio::AppInfoMonitor,
    "GApplicationCommandLine" => Gio::ApplicationCommandLine,
    "GFilterInputStream" => Gio::FilterInputStream,
    "GBufferedInputStream" => Gio::BufferedInputStream,
    "GFilterOutputStream" => Gio::FilterOutputStream,
    "GBufferedOutputStream" => Gio::BufferedOutputStream,
    "GBytesIcon" => Gio::BytesIcon,
    "GCancellable" => Gio::Cancellable,
    "GCharsetConverter" => Gio::CharsetConverter,
    "GConverterInputStream" => Gio::ConverterInputStream,
    "GConverterOutputStream" => Gio::ConverterOutputStream,
    "GCredentials" => Gio::Credentials,
    "GDBusActionGroup" => Gio::DBusActionGroup,
    "GDBusAuthObserver" => Gio::DBusAuthObserver,
    "GDBusConnection" => Gio::DBusConnection,
    "GDBusInterfaceSkeleton" => Gio::DBusInterfaceSkeleton,
    "GMenuModel" => Gio::MenuModel,
    "GDBusMenuModel" => Gio::DBusMenuModel,
    "GDBusMessage" => Gio::DBusMessage,
    "GDBusMethodInvocation" => Gio::DBusMethodInvocation,
    "GDBusObjectManagerClient" => Gio::DBusObjectManagerClient,
    "GDBusObjectManagerServer" => Gio::DBusObjectManagerServer,
    "GDBusObjectProxy" => Gio::DBusObjectProxy,
    "GDBusObjectSkeleton" => Gio::DBusObjectSkeleton,
    "GDBusProxy" => Gio::DBusProxy,
    "GDBusServer" => Gio::DBusServer,
    "GDataInputStream" => Gio::DataInputStream,
    "GDataOutputStream" => Gio::DataOutputStream,
    "GDebugControllerDBus" => Gio::DebugControllerDBus,
    "GEmblem" => Gio::Emblem,
    "GEmblemedIcon" => Gio::EmblemedIcon,
    "GFileEnumerator" => Gio::FileEnumerator,
    "GFileIOStream" => Gio::FileIOStream,
    "GFileIcon" => Gio::FileIcon,
    "GFileInfo" => Gio::FileInfo,
    "GFileInputStream" => Gio::FileInputStream,
    "GFileMonitor" => Gio::FileMonitor,
    "GFileOutputStream" => Gio::FileOutputStream,
    "GFilenameCompleter" => Gio::FilenameCompleter,
    "GIOModule" => Gio::IOModule,
    "GSocketControlMessage" => Gio::SocketControlMessage,
    "GIPTosMessage" => Gio::IPTosMessage,
    "GIPv6TclassMessage" => Gio::IPv6TclassMessage,
    "GInetAddress" => Gio::InetAddress,
    "GInetAddressMask" => Gio::InetAddressMask,
    "GSocketAddress" => Gio::SocketAddress,
    "GInetSocketAddress" => Gio::InetSocketAddress,
    "GListStore" => Gio::ListStore,
    "GMemoryInputStream" => Gio::MemoryInputStream,
    "GMemoryOutputStream" => Gio::MemoryOutputStream,
    "GMenu" => Gio::Menu,
    "GMenuAttributeIter" => Gio::MenuAttributeIter,
    "GMenuItem" => Gio::MenuItem,
    "GMenuLinkIter" => Gio::MenuLinkIter,
    "GMountOperation" => Gio::MountOperation,
    "GNativeSocketAddress" => Gio::NativeSocketAddress,
    "GVolumeMonitor" => Gio::VolumeMonitor,
    "GNativeVolumeMonitor" => Gio::NativeVolumeMonitor,
    "GNetworkAddress" => Gio::NetworkAddress,
    "GNetworkService" => Gio::NetworkService,
    "GNotification" => Gio::Notification,
    "GPermission" => Gio::Permission,
    "GPropertyAction" => Gio::PropertyAction,
    "GProxyAddress" => Gio::ProxyAddress,
    "GSocketAddressEnumerator" => Gio::SocketAddressEnumerator,
    "GProxyAddressEnumerator" => Gio::ProxyAddressEnumerator,
    "GResolver" => Gio::Resolver,
    "GSettings" => Gio::Settings,
    "GSettingsBackend" => Gio::SettingsBackend,
    "GSimpleAction" => Gio::SimpleAction,
    "GSimpleActionGroup" => Gio::SimpleActionGroup,
    "GSimpleAsyncResult" => Gio::SimpleAsyncResult,
    "GSimpleIOStream" => Gio::SimpleIOStream,
    "GSimplePermission" => Gio::SimplePermission,
    "GSimpleProxyResolver" => Gio::SimpleProxyResolver,
    "GSocket" => Gio::Socket,
    "GSocketClient" => Gio::SocketClient,
    "GSocketConnection" => Gio::SocketConnection,
    "GSocketListener" => Gio::SocketListener,
    "GSocketService" => Gio::SocketService,
    "GSubprocess" => Gio::Subprocess,
    "GSubprocessLauncher" => Gio::SubprocessLauncher,
    "GTask" => Gio::Task,
    "GTcpConnection" => Gio::TcpConnection,
    "GTcpWrapperConnection" => Gio::TcpWrapperConnection,
    "GTestDBus" => Gio::TestDBus,
    "GThemedIcon" => Gio::ThemedIcon,
    "GThreadedResolver" => Gio::ThreadedResolver,
    "GThreadedSocketService" => Gio::ThreadedSocketService,
    "GTlsCertificate" => Gio::TlsCertificate,
    "GTlsInteraction" => Gio::TlsInteraction,
    "GTlsPassword" => Gio::TlsPassword,
    "GUnixConnection" => Gio::UnixConnection,
    "GUnixCredentialsMessage" => Gio::UnixCredentialsMessage,
    "GUnixFDList" => Gio::UnixFDList,
    "GUnixSocketAddress" => Gio::UnixSocketAddress,
    "GVfs" => Gio::Vfs,
    "GZlibCompressor" => Gio::ZlibCompressor,
    "GZlibDecompressor" => Gio::ZlibDecompressor,
    "GskRenderNode" => Gsk::RenderNode,
    "GskBlendNode" => Gsk::BlendNode,
    "GskBlurNode" => Gsk::BlurNode,
    "GskBorderNode" => Gsk::BorderNode,
    "GskRenderer" => Gsk::Renderer,
    "GskBroadwayRenderer" => Gsk::BroadwayRenderer,
    "GskCairoNode" => Gsk::CairoNode,
    "GskCairoRenderer" => Gsk::CairoRenderer,
    "GskClipNode" => Gsk::ClipNode,
    "GskColorMatrixNode" => Gsk::ColorMatrixNode,
    "GskColorNode" => Gsk::ColorNode,
    "GskComponentTransferNode" => Gsk::ComponentTransferNode,
    "GskCompositeNode" => Gsk::CompositeNode,
    "GskConicGradientNode" => Gsk::ConicGradientNode,
    "GskContainerNode" => Gsk::ContainerNode,
    "GskCopyNode" => Gsk::CopyNode,
    "GskCrossFadeNode" => Gsk::CrossFadeNode,
    "GskDebugNode" => Gsk::DebugNode,
    "GskFillNode" => Gsk::FillNode,
    "GskGLRenderer" => Gsk::GLRenderer,
    "GskGLShader" => Gsk::GLShader,
    "GskGLShaderNode" => Gsk::GLShaderNode,
    "GskInsetShadowNode" => Gsk::InsetShadowNode,
    "GskIsolationNode" => Gsk::IsolationNode,
    "GskLinearGradientNode" => Gsk::LinearGradientNode,
    "GskMaskNode" => Gsk::MaskNode,
    "GskNglRenderer" => Gsk::NglRenderer,
    "GskOpacityNode" => Gsk::OpacityNode,
    "GskOutsetShadowNode" => Gsk::OutsetShadowNode,
    "GskPasteNode" => Gsk::PasteNode,
    "GskRadialGradientNode" => Gsk::RadialGradientNode,
    "GskRepeatNode" => Gsk::RepeatNode,
    "GskRepeatingLinearGradientNode" => Gsk::RepeatingLinearGradientNode,
    "GskRepeatingRadialGradientNode" => Gsk::RepeatingRadialGradientNode,
    "GskRoundedClipNode" => Gsk::RoundedClipNode,
    "GskShadowNode" => Gsk::ShadowNode,
    "GskStrokeNode" => Gsk::StrokeNode,
    "GskSubsurfaceNode" => Gsk::SubsurfaceNode,
    "GskTextNode" => Gsk::TextNode,
    "GskTextureNode" => Gsk::TextureNode,
    "GskTextureScaleNode" => Gsk::TextureScaleNode,
    "GskTransformNode" => Gsk::TransformNode,
    "GskVulkanRenderer" => Gsk::VulkanRenderer,
    "GtkATContext" => Gtk::ATContext,
    "GtkAboutDialog" => Gtk::AboutDialog,
    "GtkAccessibleHyperlink" => Gtk::AccessibleHyperlink,
    "GtkActionBar" => Gtk::ActionBar,
    "GtkShortcutAction" => Gtk::ShortcutAction,
    "GtkActivateAction" => Gtk::ActivateAction,
    "GtkAdjustment" => Gtk::Adjustment,
    "GtkAlertDialog" => Gtk::AlertDialog,
    "GtkShortcutTrigger" => Gtk::ShortcutTrigger,
    "GtkAlternativeTrigger" => Gtk::AlternativeTrigger,
    "GtkFilter" => Gtk::Filter,
    "GtkMultiFilter" => Gtk::MultiFilter,
    "GtkAnyFilter" => Gtk::AnyFilter,
    "GtkAppChooserButton" => Gtk::AppChooserButton,
    "GtkDialog" => Gtk::Dialog,
    "GtkAppChooserDialog" => Gtk::AppChooserDialog,
    "GtkAppChooserWidget" => Gtk::AppChooserWidget,
    "GtkAspectFrame" => Gtk::AspectFrame,
    "GtkAssistant" => Gtk::Assistant,
    "GtkAssistantPage" => Gtk::AssistantPage,
    "GtkBinLayout" => Gtk::BinLayout,
    "GtkBookmarkList" => Gtk::BookmarkList,
    "GtkBoolFilter" => Gtk::BoolFilter,
    "GtkBox" => Gtk::Box,
    "GtkBoxLayout" => Gtk::BoxLayout,
    "GtkBuilder" => Gtk::Builder,
    "GtkBuilderCScope" => Gtk::BuilderCScope,
    "GtkListItemFactory" => Gtk::ListItemFactory,
    "GtkBuilderListItemFactory" => Gtk::BuilderListItemFactory,
    "GtkButton" => Gtk::Button,
    "GtkExpression" => Gtk::Expression,
    "GtkCClosureExpression" => Gtk::CClosureExpression,
    "GtkCalendar" => Gtk::Calendar,
    "GtkCallbackAction" => Gtk::CallbackAction,
    "GtkCellArea" => Gtk::CellArea,
    "GtkCellAreaBox" => Gtk::CellAreaBox,
    "GtkCellAreaContext" => Gtk::CellAreaContext,
    "GtkCellRenderer" => Gtk::CellRenderer,
    "GtkCellRendererText" => Gtk::CellRendererText,
    "GtkCellRendererAccel" => Gtk::CellRendererAccel,
    "GtkCellRendererCombo" => Gtk::CellRendererCombo,
    "GtkCellRendererPixbuf" => Gtk::CellRendererPixbuf,
    "GtkCellRendererProgress" => Gtk::CellRendererProgress,
    "GtkCellRendererSpin" => Gtk::CellRendererSpin,
    "GtkCellRendererSpinner" => Gtk::CellRendererSpinner,
    "GtkCellRendererToggle" => Gtk::CellRendererToggle,
    "GtkCellView" => Gtk::CellView,
    "GtkCenterBox" => Gtk::CenterBox,
    "GtkCenterLayout" => Gtk::CenterLayout,
    "GtkCheckButton" => Gtk::CheckButton,
    "GtkClosureExpression" => Gtk::ClosureExpression,
    "GtkColorButton" => Gtk::ColorButton,
    "GtkColorChooserDialog" => Gtk::ColorChooserDialog,
    "GtkColorChooserWidget" => Gtk::ColorChooserWidget,
    "GtkColorDialog" => Gtk::ColorDialog,
    "GtkColorDialogButton" => Gtk::ColorDialogButton,
    "GtkColumnView" => Gtk::ColumnView,
    "GtkListItem" => Gtk::ListItem,
    "GtkColumnViewCell" => Gtk::ColumnViewCell,
    "GtkColumnViewColumn" => Gtk::ColumnViewColumn,
    "GtkColumnViewRow" => Gtk::ColumnViewRow,
    "GtkSorter" => Gtk::Sorter,
    "GtkColumnViewSorter" => Gtk::ColumnViewSorter,
    "GtkComboBox" => Gtk::ComboBox,
    "GtkComboBoxText" => Gtk::ComboBoxText,
    "GtkConstantExpression" => Gtk::ConstantExpression,
    "GtkConstraint" => Gtk::Constraint,
    "GtkConstraintGuide" => Gtk::ConstraintGuide,
    "GtkConstraintLayout" => Gtk::ConstraintLayout,
    "GtkLayoutChild" => Gtk::LayoutChild,
    "GtkConstraintLayoutChild" => Gtk::ConstraintLayoutChild,
    "GtkCssProvider" => Gtk::CssProvider,
    "GtkCustomFilter" => Gtk::CustomFilter,
    "GtkCustomLayout" => Gtk::CustomLayout,
    "GtkCustomSorter" => Gtk::CustomSorter,
    "GtkDirectoryList" => Gtk::DirectoryList,
    "GtkDragIcon" => Gtk::DragIcon,
    "GtkEventController" => Gtk::EventController,
    "GtkGesture" => Gtk::Gesture,
    "GtkGestureSingle" => Gtk::GestureSingle,
    "GtkDragSource" => Gtk::DragSource,
    "GtkDrawingArea" => Gtk::DrawingArea,
    "GtkDropControllerMotion" => Gtk::DropControllerMotion,
    "GtkDropDown" => Gtk::DropDown,
    "GtkDropTarget" => Gtk::DropTarget,
    "GtkDropTargetAsync" => Gtk::DropTargetAsync,
    "GtkEditableLabel" => Gtk::EditableLabel,
    "GtkPopover" => Gtk::Popover,
    "GtkEmojiChooser" => Gtk::EmojiChooser,
    "GtkEntry" => Gtk::Entry,
    "GtkEntryBuffer" => Gtk::EntryBuffer,
    "GtkEntryCompletion" => Gtk::EntryCompletion,
    "GtkEventControllerFocus" => Gtk::EventControllerFocus,
    "GtkEventControllerKey" => Gtk::EventControllerKey,
    "GtkEventControllerLegacy" => Gtk::EventControllerLegacy,
    "GtkEventControllerMotion" => Gtk::EventControllerMotion,
    "GtkEventControllerScroll" => Gtk::EventControllerScroll,
    "GtkEveryFilter" => Gtk::EveryFilter,
    "GtkExpander" => Gtk::Expander,
    "GtkFileChooserDialog" => Gtk::FileChooserDialog,
    "GtkNativeDialog" => Gtk::NativeDialog,
    "GtkFileChooserNative" => Gtk::FileChooserNative,
    "GtkFileChooserWidget" => Gtk::FileChooserWidget,
    "GtkFileDialog" => Gtk::FileDialog,
    "GtkFileFilter" => Gtk::FileFilter,
    "GtkFileLauncher" => Gtk::FileLauncher,
    "GtkFilterListModel" => Gtk::FilterListModel,
    "GtkFixed" => Gtk::Fixed,
    "GtkFixedLayout" => Gtk::FixedLayout,
    "GtkFixedLayoutChild" => Gtk::FixedLayoutChild,
    "GtkFlattenListModel" => Gtk::FlattenListModel,
    "GtkFlowBox" => Gtk::FlowBox,
    "GtkFlowBoxChild" => Gtk::FlowBoxChild,
    "GtkFontButton" => Gtk::FontButton,
    "GtkFontChooserDialog" => Gtk::FontChooserDialog,
    "GtkFontChooserWidget" => Gtk::FontChooserWidget,
    "GtkFontDialog" => Gtk::FontDialog,
    "GtkFontDialogButton" => Gtk::FontDialogButton,
    "GtkFrame" => Gtk::Frame,
    "GtkGLArea" => Gtk::GLArea,
    "GtkGestureClick" => Gtk::GestureClick,
    "GtkGestureDrag" => Gtk::GestureDrag,
    "GtkGestureLongPress" => Gtk::GestureLongPress,
    "GtkGesturePan" => Gtk::GesturePan,
    "GtkGestureRotate" => Gtk::GestureRotate,
    "GtkGestureStylus" => Gtk::GestureStylus,
    "GtkGestureSwipe" => Gtk::GestureSwipe,
    "GtkGestureZoom" => Gtk::GestureZoom,
    "GtkGraphicsOffload" => Gtk::GraphicsOffload,
    "GtkGrid" => Gtk::Grid,
    "GtkGridLayout" => Gtk::GridLayout,
    "GtkGridLayoutChild" => Gtk::GridLayoutChild,
    "GtkListBase" => Gtk::ListBase,
    "GtkGridView" => Gtk::GridView,
    "GtkHeaderBar" => Gtk::HeaderBar,
    "GtkIMContext" => Gtk::IMContext,
    "GtkIMContextSimple" => Gtk::IMContextSimple,
    "GtkIMMulticontext" => Gtk::IMMulticontext,
    "GtkIconPaintable" => Gtk::IconPaintable,
    "GtkIconTheme" => Gtk::IconTheme,
    "GtkIconView" => Gtk::IconView,
    "GtkImage" => Gtk::Image,
    "GtkInfoBar" => Gtk::InfoBar,
    "GtkInscription" => Gtk::Inscription,
    "GtkKeyvalTrigger" => Gtk::KeyvalTrigger,
    "GtkLabel" => Gtk::Label,
    "GtkLevelBar" => Gtk::LevelBar,
    "GtkLinkButton" => Gtk::LinkButton,
    "GtkListBox" => Gtk::ListBox,
    "GtkListHeader" => Gtk::ListHeader,
    "GtkListStore" => Gtk::ListStore,
    "GtkListView" => Gtk::ListView,
    "GtkLockButton" => Gtk::LockButton,
    "GtkMapListModel" => Gtk::MapListModel,
    "GtkMediaControls" => Gtk::MediaControls,
    "GtkMediaStream" => Gtk::MediaStream,
    "GtkMediaFile" => Gtk::MediaFile,
    "GtkMenuButton" => Gtk::MenuButton,
    "GtkMessageDialog" => Gtk::MessageDialog,
    "GtkMnemonicAction" => Gtk::MnemonicAction,
    "GtkMnemonicTrigger" => Gtk::MnemonicTrigger,
    "GtkMountOperation" => Gtk::MountOperation,
    "GtkMultiSelection" => Gtk::MultiSelection,
    "GtkMultiSorter" => Gtk::MultiSorter,
    "GtkNamedAction" => Gtk::NamedAction,
    "GtkNeverTrigger" => Gtk::NeverTrigger,
    "GtkNoSelection" => Gtk::NoSelection,
    "GtkNotebook" => Gtk::Notebook,
    "GtkNotebookPage" => Gtk::NotebookPage,
    "GtkNothingAction" => Gtk::NothingAction,
    "GtkNumericSorter" => Gtk::NumericSorter,
    "GtkObjectExpression" => Gtk::ObjectExpression,
    "GtkOverlay" => Gtk::Overlay,
    "GtkOverlayLayout" => Gtk::OverlayLayout,
    "GtkOverlayLayoutChild" => Gtk::OverlayLayoutChild,
    "GtkPadController" => Gtk::PadController,
    "GtkPageSetup" => Gtk::PageSetup,
    "GtkPageSetupUnixDialog" => Gtk::PageSetupUnixDialog,
    "GtkPaned" => Gtk::Paned,
    "GtkParamSpecExpression" => Gtk::ParamSpecExpression,
    "GtkPasswordEntry" => Gtk::PasswordEntry,
    "GtkPasswordEntryBuffer" => Gtk::PasswordEntryBuffer,
    "GtkPicture" => Gtk::Picture,
    "GtkPopoverBin" => Gtk::PopoverBin,
    "GtkPopoverMenu" => Gtk::PopoverMenu,
    "GtkPopoverMenuBar" => Gtk::PopoverMenuBar,
    "GtkPrintContext" => Gtk::PrintContext,
    "GtkPrintDialog" => Gtk::PrintDialog,
    "GtkPrintJob" => Gtk::PrintJob,
    "GtkPrintOperation" => Gtk::PrintOperation,
    "GtkPrintSettings" => Gtk::PrintSettings,
    "GtkPrintUnixDialog" => Gtk::PrintUnixDialog,
    "GtkPrinter" => Gtk::Printer,
    "GtkProgressBar" => Gtk::ProgressBar,
    "GtkPropertyExpression" => Gtk::PropertyExpression,
    "GtkRange" => Gtk::Range,
    "GtkRecentManager" => Gtk::RecentManager,
    "GtkRevealer" => Gtk::Revealer,
    "GtkScale" => Gtk::Scale,
    "GtkScaleButton" => Gtk::ScaleButton,
    "GtkScrollbar" => Gtk::Scrollbar,
    "GtkScrolledWindow" => Gtk::ScrolledWindow,
    "GtkSearchBar" => Gtk::SearchBar,
    "GtkSearchEntry" => Gtk::SearchEntry,
    "GtkSelectionFilterModel" => Gtk::SelectionFilterModel,
    "GtkSeparator" => Gtk::Separator,
    "GtkSettings" => Gtk::Settings,
    "GtkShortcut" => Gtk::Shortcut,
    "GtkShortcutController" => Gtk::ShortcutController,
    "GtkShortcutLabel" => Gtk::ShortcutLabel,
    "GtkShortcutsGroup" => Gtk::ShortcutsGroup,
    "GtkShortcutsSection" => Gtk::ShortcutsSection,
    "GtkShortcutsShortcut" => Gtk::ShortcutsShortcut,
    "GtkShortcutsWindow" => Gtk::ShortcutsWindow,
    "GtkSignalAction" => Gtk::SignalAction,
    "GtkSignalListItemFactory" => Gtk::SignalListItemFactory,
    "GtkSingleSelection" => Gtk::SingleSelection,
    "GtkSizeGroup" => Gtk::SizeGroup,
    "GtkSliceListModel" => Gtk::SliceListModel,
    "GtkSnapshot" => Gtk::Snapshot,
    "GtkSortListModel" => Gtk::SortListModel,
    "GtkSpinButton" => Gtk::SpinButton,
    "GtkSpinner" => Gtk::Spinner,
    "GtkStack" => Gtk::Stack,
    "GtkStackPage" => Gtk::StackPage,
    "GtkStackSidebar" => Gtk::StackSidebar,
    "GtkStackSwitcher" => Gtk::StackSwitcher,
    "GtkStatusbar" => Gtk::Statusbar,
    "GtkStringFilter" => Gtk::StringFilter,
    "GtkStringList" => Gtk::StringList,
    "GtkStringObject" => Gtk::StringObject,
    "GtkStringSorter" => Gtk::StringSorter,
    "GtkStyleContext" => Gtk::StyleContext,
    "GtkSvg" => Gtk::Svg,
    "GtkSwitch" => Gtk::Switch,
    "GtkText" => Gtk::Text,
    "GtkTextBuffer" => Gtk::TextBuffer,
    "GtkTextChildAnchor" => Gtk::TextChildAnchor,
    "GtkTextMark" => Gtk::TextMark,
    "GtkTextTag" => Gtk::TextTag,
    "GtkTextTagTable" => Gtk::TextTagTable,
    "GtkTextView" => Gtk::TextView,
    "GtkToggleButton" => Gtk::ToggleButton,
    "GtkTooltip" => Gtk::Tooltip,
    "GtkTreeExpander" => Gtk::TreeExpander,
    "GtkTreeListModel" => Gtk::TreeListModel,
    "GtkTreeListRow" => Gtk::TreeListRow,
    "GtkTreeListRowSorter" => Gtk::TreeListRowSorter,
    "GtkTreeModelFilter" => Gtk::TreeModelFilter,
    "GtkTreeModelSort" => Gtk::TreeModelSort,
    "GtkTreeSelection" => Gtk::TreeSelection,
    "GtkTreeStore" => Gtk::TreeStore,
    "GtkTreeView" => Gtk::TreeView,
    "GtkTreeViewColumn" => Gtk::TreeViewColumn,
    "GtkTryExpression" => Gtk::TryExpression,
    "GtkUriLauncher" => Gtk::UriLauncher,
    "GtkVideo" => Gtk::Video,
    "GtkViewport" => Gtk::Viewport,
    "GtkVolumeButton" => Gtk::VolumeButton,
    "GtkWidgetPaintable" => Gtk::WidgetPaintable,
    "GtkWindowControls" => Gtk::WindowControls,
    "GtkWindowGroup" => Gtk::WindowGroup,
    "GtkWindowHandle" => Gtk::WindowHandle,
    "PangoContext" => Pango::Context,
    "PangoCoverage" => Pango::Coverage,
    "PangoFontFace" => Pango::FontFace,
    "PangoFontFamily" => Pango::FontFamily,
    "PangoFontset" => Pango::Fontset,
    "PangoFontsetSimple" => Pango::FontsetSimple,
    "PangoLayout" => Pango::Layout,
    "PangoRenderer" => Pango::Renderer,
  }.freeze
end
