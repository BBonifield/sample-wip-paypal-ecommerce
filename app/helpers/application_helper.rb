module ApplicationHelper

  def active_nav_item_when_current_page *args, &link_block
    link_name = args[0]
    link_options = args[1]
    link_html_options = args[2]

    if current_page? link_options
      nav_item_html_options = {:class => 'active'}
    end

    content_tag :li,
      link_to(link_name, link_options, link_html_options, link_block),
      nav_item_html_options
  end


  def address_lines address
    lines = []
    lines << address.address_1
    lines << address.address_2 if address.address_2.present?
    lines << "#{address.city}, #{address.state} #{address.zip_code}"

    lines
  end


  def category_options
    options_with_select(Category.all.map { |c| [c.name, c.id] })
  end

  def condition_options
    options_with_select(Condition.all.map { |c| [c.name, c.id] })
  end

  def shipping_speed_options
    options_with_select(ShippingSpeed.all.map { |c| [c.name, c.id] })
  end

  def shipping_service_options
    options_with_select(ShippingService.all.map { |c| [c.name, c.id] })
  end


  def options_with_none options
    [['Not Specified', '']] + options
  end

  def options_with_select options
    [['Select...', '']] + options
  end
end
