module ApplicationHelper
  def flash_message_class(message_type)
    base_classes = "bg-opacity-75 text-white"
    case message_type.to_sym
    when :success
      "#{base_classes} bg-green-500"
    when :error
      "#{base_classes} bg-red-500"
    when :alert
      "#{base_classes} bg-yellow-500"
    when :notice
      "#{base_classes} bg-blue-500"
    else
      base_classes
    end
  end
end
