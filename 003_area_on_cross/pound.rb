
class Pound
    SHAPE_FLAT = 0
    SHAPE_DOWN = 1
    SHAPE_RISE = 2

    def initialize
        @depth = [0,0]
        @width = 0
    end

    def deform(simbol)
        if  @depth[1] == 0  then
            @width = 0
        else
            @width += 1
        end
        @depth[0] = @depth[1]
        case simbol
        when '\\'
            @depth[1] += 1
        when '/'
            @depth[1] -= 1  if  @depth[1] > 0
        when '_'
            #pass
        end
        #p @depth
    end

    def area_get
        if  @depth == [0,0]  then
            return 0
        end
        @depth[0] + @depth[1]
    end

    def is_touch_air
        @depth[1] == 0
    end

end #pound

def map_cut_right_flood(map)
    while map[-1] == '\\' || map[-1] == '_'
        map.slice!(map.length-1)
    end
end

def map_cut_left_flood(map)
    while map[0] != '/'  &&  map.length > 0
        if  map[0] == '_'  then
            map.slice!(0)
            next
        end
        l = map.length
        d_cnt = 1
        u_cnt = 0
        pnd = Pound.new()
        pnd.deform('\\')
        map[1..l].chars.each do |s|
            case s
            when '\\'
                d_cnt += 1
            when '/'
                u_cnt += 1
            end
            pnd.deform(s)
            break if  pnd.is_touch_air
        end
        if  d_cnt > u_cnt  then
            #map.slice!(0, d_cnt - u_cnt)
            map.slice!(0)
        else
            break
        end
    end
    #puts "cut_left > " + map
end


map = (gets).strip
pound = Pound.new()

map_cut_right_flood(map)
#puts map

areas = []
area_num = 0
areas[area_num] = 0

posi = 0
while posi < map.length
    map_cut_left_flood(map)

    map.chars.each do |simbol|
        posi += 1
        pound.deform(simbol)
        a = pound.area_get
        areas[area_num] += a
        #puts simbol + " : " + pound.area_get().to_s
        #puts pound.area_get().to_s
        if  pound.is_touch_air  &&  areas[area_num] >= 0  then
            area_num += 1
            areas[area_num] = 0
            #puts map.slice!(0, posi)
            map.slice!(0, posi)
            posi = 0
            break
        end
    end
end

n = 0
areas.each {|a|  n += 1  if  a > 0}

puts areas.sum/2
print n
areas.each {|a|  print " #{a/2}"  if  a > 0}

