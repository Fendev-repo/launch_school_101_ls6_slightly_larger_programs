require 'pry-byebug'
=begin 
Currently, we're using the Array#join method, which can only insert a delimiter between the array elements, and isn't smart enough to display a joining word for the last element.

Write a method called joinor that will produce the following result:

joinor([1, 2])                   # => "1 or 2"
joinor([1, 2, 3])                # => "1, 2, or 3"
joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"
=end

# Option 1.

# def joinor(arr, delim=', ', seperator='or')
#   updated_arr = arr.map do |item|
#     item.to_s + delim
#   end 
  
#   last_item = updated_arr.pop[0]

  
#   if updated_arr.length < 2
#     first_item = updated_arr[0][0]
#     "#{first_item} #{"or"} #{last_item}"
#   else
#     # binding.pry 
#     new_last_item = updated_arr.pop[0]
#     updated_arr.push(new_last_item)
#     "#{updated_arr.join} #{seperator} #{last_item}"
#   end
# end


# Option 2.

def joinor(arr, delim=", ", seperator='or')
  length = arr.length
  
  case length
  when 0
    ''
  when 2
    "#{arr.first} #{seperator} #{arr.last}"
  else 
    last_item = arr.last
    arr = arr.join(delim)
    arr[-1] = "#{seperator} #{last_item}"
    "#{arr}"
  end
end


p joinor([]) 
p joinor([1, 2])                   # => "1 or 2"
p joinor([1, 2, 3])                # => "1, 2, or 3"
p joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
p joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"



