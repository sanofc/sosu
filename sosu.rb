def sosu(num)
	2.upto(num-1){|i|
		if num % i == 0
			return false
		end
	}
	return true
end

2.upto(1000){|i|
	if sosu(i)
		print i,"!"
	end
}
