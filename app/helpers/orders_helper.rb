module OrdersHelper

  def address_options
    options_with_select(current_user.addresses.map { |a| [a.name, a.id] } )
  end

end
