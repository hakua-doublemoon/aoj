N,K = (gets).split(" ").map {|v| v.to_i}
baggeges = []
pp = 0

N.times do
    bg = (gets).to_i
    baggeges << bg
    pp += bg
end
baggeges << 0

up_p = pp
dw_p = baggeges.max
check_list = []
ans = 0
while  true  do
    cur_p = (up_p + dw_p).div(2)
    if  check_list.include?(cur_p)  then
        if  check_list.include?(cur_p+1)  then
            break
        else
            cur_p += 1
        end
    end
    #puts "\n--[#{cur_p}]---------"
    check_list << cur_p
    trk = 0
    trk_num = 0
    can_load = true
    baggeges.each do |bag|
        t = trk + bag
        if  t > cur_p   then
            trk_num += 1
            trk = bag
            if  trk_num == K  then
                can_load = false
                #print "#{bag} "
                break
            end
            #puts ""
        else
            trk = t
        end
        #print "#{bag} "
    end
    if  can_load  then
        up_p = cur_p
        ans = cur_p
    else
        dw_p = cur_p
    end
end

puts ans

