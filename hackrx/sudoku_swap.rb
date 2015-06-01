# Enter your code here. Read input from STDIN. Print output to
data = STDIN.read.split("\n")
data.shift()
data = data.map { |d| d.split(" ").map { |a| Integer(a) } }

class Game
    attr_accessor :rows, :invalid_sqs, :cache
    def initialize(rows)
        @rows = rows
        @cache = Array.new(3) { Array.new(9) {{}}}
        @invalid_sqs = build_cache        
    end
    
    def build_cache
        invalids = []
        rows.each_with_index do |row, i|
            row.each_with_index do |v, j|
                cache.each_with_index do |section_type, k|
                    assign_to_cache(section_type, k, [i, j], v).each do |invalid| 
                        invalids.push(invalid) if invalids.none? { |item| item == invalid }
                    end
                end
            end
        end
        invalids
    end
    def assign_to_cache(section_type, k, idx, v)
        invalids = []
        if k == 0
            section = idx[0]
        elsif k == 1
            section = idx[1]
        else
            section = get_sq(idx)
        end

        cache_val = section_type[section][v]
        
        if cache_val
            cache_val.push(idx)
            cache_val.each { |ind| invalids.push(ind) }
        else
            section_type[section][v] = [idx]
        end 
        invalids
    end
    def get_sq(idx)
        (idx[0]/3*3) + idx[1]/3
    end
    def not_needed(i, j, val)
        cache[i][j][val].length > 1
    end
    def is_needed(i, j, val)
        cache[i][j][val].length == 1
    end
    def can_swap(first, second)
        f = is_needed_for(first)
        s = is_needed_for(second)
        # whats the logic??
        # can't switch if needed for col and for row
        return false if f["col"] && f["row"] || s["row"] && s["col"]
        # if its needed for the row and 

        row = f["row"] && s["row"] && f["idx"][0] == s["idx"][0] || !f["row"] && !s["row"]
        col = f["col"] && s["col"] && f["idx"][1] == s["idx"][1] || !f["col"] && !s["col"]
        sq = f["sq"] && s["sq"] && get_sq(first) == get_sq(second) || !f["sq"] && !s["sq"]
        
        row && col && sq
    end

    def is_needed_for(idx)
        val = rows[idx[0]][idx[1]]
        c = {}
        c["row"] = is_needed(0, idx[0], val)
        c["col"] = is_needed(1, idx[1], val)
        c["sq"] = is_needed(2, get_sq(idx), val)
        c["idx"] = idx
        c["val"] = val
        c
    end
    def find_results
        return "Serendipity" if invalid_sqs.none?
        value_cache = {}
        invalid_sqs.each do |idx|
            val = rows[idx[0]][idx[1]]
            extend_cache(value_cache, val, idx)
        end
        a = value_cache.each_with_object([]) { |(k,v), a| a.push(v) }
        a[0].each do |first|
            a[1].each do |second|
                puts format_output([first.map {|x| x+1}, second.map {|x| x+1}].sort) if can_swap(first, second)
            end
        end
    end
    def format_output(s)
        "(" + s[0][0].to_s + "," + s[0][1].to_s + ") <-> (" + s[1][0].to_s + "," + s[1][1].to_s + ")" 
    end
    def extend_cache(cache, k, v)
        cache[k] ? cache[k].push(v) : cache[k] = [v]
    end
   
end

data.each_slice(9).to_a.each_with_index do |rows, i|
    g = Game.new(rows)
    puts "Case #" + (i+1).to_s + ":"
    results = g.find_results 
    if results.is_a? String
        puts results
    #else
    #    results.each do |k,v|
    #        g.process_cache(v) unless v.keys.length < 2
    #    end
    end
    
end
4 
2 1 9 7 5 3 4 8 6
3 7 5 8 6 4 9 1 2 
8 4 6 2 9 1 3 5 7 
1 9 8 6 7 5 2 4 3 
5 6 4 1 3 2 7 9 8 
7 2 3 4 8 9 5 6 1 
4 4 7 3 1 6 8 2 9 
9 8 1 5 2 7 6 3 4 
6 3 2 9 5 8 1 7 5
4 6 2 5 7 1 9 8 3 
7 9 1 2 8 3 4 6 5 
5 8 3 6 4 9 2 7 1 
6 1 7 4 9 8 5 3 2 
9 4 8 3 5 2 6 1 7 
2 3 5 1 6 7 8 9 4 
1 7 6 9 2 4 3 5 8 
3 5 4 8 1 6 7 2 9 
8 2 9 7 3 5 1 4 6
1 2 3 4 1 6 7 8 9 
4 5 6 7 8 9 1 2 3 
7 8 9 1 2 3 4 5 6 
5 3 4 6 5 8 9 7 2 
6 1 2 3 9 7 5 4 8 
9 7 8 2 4 5 6 3 1 
3 4 7 9 6 2 8 1 5 
2 9 5 8 7 1 3 6 4 
8 6 1 5 3 4 2 9 7
2 1 9 7 5 3 4 8 6 
3 5 7 8 6 4 9 1 2 
8 4 6 2 9 1 3 5 7 
1 9 8 6 7 5 2 4 3 
5 6 4 1 3 2 7 9 8 
7 2 3 4 8 9 5 6 1 
4 5 7 3 1 6 8 2 9 
9 8 1 5 2 7 6 3 4 
6 3 2 9 4 8 1 7 5