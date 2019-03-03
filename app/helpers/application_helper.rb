# frozen_string_literal: true

module ApplicationHelper

  def remove_child_link(name, f, options = {})
    confirm = options.delete(:confirm)
    confirm = confirm.nil? ? true : confirm
    f.hidden_field(:_destroy) + link_to(name, '#', onclick: "if (#{confirm ? 'false' : 'true'} || confirm('Do you really want to remove this item?')) remove_fields(this); return false;")
  end

  def add_child_link(name, f, method, options = {})
    fields = new_child_fields(f, method, options)
    link_to(name, '#', onclick: "insert_fields(this, \"#{method}\", \"#{escape_javascript(fields)}\"); return false;")
  end

  def new_child_fields(form_builder, method, options = {})
    options[:object] ||= form_builder.object.class.reflect_on_association(method).klass.new
    options[:partial] ||= method.to_s.singularize
    options[:form_builder_local] ||= :f
    form_builder.fields_for(method, options[:object], :child_index => "new_#{method}") do |f|
      render(:partial => options[:partial], :locals => { options[:form_builder_local] => f })
    end
  end
  
end
