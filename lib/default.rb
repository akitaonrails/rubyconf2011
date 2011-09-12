# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

def menu(item)
  if @item[:menu] && @item[:menu] == item
    " class=\"activeMenu\""
  else
    ""
  end
end
