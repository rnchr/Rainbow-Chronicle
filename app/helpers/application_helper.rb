module ApplicationHelper
  def display_categories(objects)
    list = {}
    objects.each do |o|
      o.tags.each do |t|
        path = t.ancestry_path
        if list[path[0]].nil?
          list[path[0]] = {:count => 1, :sub => []}
        else
          list[path[0]][:count] += 1
        end
        list[path[0]][:sub] << path[1]
      end
    end
    
    ret = "<ul class=\"unstyled\">"
    
    list = list.sort {|a,b| b[1][:count] <=> a[1][:count] }
    list[0..5].each do |cat|
      b = Hash.new(0)
      cat[1][:sub].each do |v|
        b[v] += 1
      end
      ret << "<li>#{cat[0]} (#{cat[1][:sub].count})</li><ul>"
      b.each do |k, v|
        ret << "<li>#{k} (#{v})</li>\n"
      end
      ret << "</ul>"
    end
    ret += "</ul>"
  end
end
