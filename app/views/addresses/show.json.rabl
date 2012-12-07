object @address

attributes :id, :name
node :address_lines do |address|
  address_lines(address)
end
