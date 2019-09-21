N,K = (gets).split(" ").map {|v| v.to_i}
bags = []
pp = 0

N.times do
    bg = (gets).to_i
    bags << bg
    pp += bg
end
bags.sort!

trucks = Array.new(K) {[]}
trucks[0] = bags

def max_truck_get(trucks)
    m = 0
    max_truck_no = 0
    trucks.each.with_index do |trk, t_idx|
        s = trk.sum
        if  s > m  then
            m = s
            max_truck_no = t_idx
        end
    end
    [max_truck_no, m]
end

def truck_try_load(trucks, bag, p)
    puts "p = #{p} [#{bag}]"
    trucks.each {|t| p t}

    ready_truck_no = -1
    min_truck_no = -1
    m = p
    trucks.each.with_index do |trk, t_idx|
        s = trk.sum
        if  m > s  then
            m = s
            min_truck_no = t_idx
        end
        if  (s + bag) <= p  then
            ready_truck_no = t_idx
            break
        end
    end
    [ready_truck_no, min_truck_no]
end

while  pp > 0  do
    max_truck_no,pp = max_truck_get(trucks)
    bag = trucks[max_truck_no].shift
    p = pp - bag
    ready_truck_no,min_truck_no = truck_try_load(trucks, bag, p)
    if  ready_truck_no == -1   then
        # 一番空いてるトラックの一番小さい要素と交換してみる ?
        trucks[max_truck_no].unshift(bag) # デバッグ用
        break
    end
    trucks[ready_truck_no].push(bag)
    trucks[ready_truck_no].sort!
    pp = p
end

#trucks.each {|t| p t}
puts pp 

