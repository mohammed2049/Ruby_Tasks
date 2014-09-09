
class Numeric
  @@currencies = {egp: 1  , dollar: 7.15 , euro: 9.26, yen: 0.068}
  @@change = {dollar: 'USD' , egp: 'EGP' , euro: 'EUR' , yen: 'JPY'}

  def self.currencies
  	@@currencies
  end

  def self.add_currency(option = {})
  	@@currencies[option.keys[0]] = option[option.keys[0]];
  end

  def convert_currency(from , to) 
  	from = from[0...(from.length-1)] if from[from.length-1] == 's'
  	to = to[0...(to.length-1)] if to[to.length-1] == 's'
  	a = from.to_sym
  	b = to.to_sym
  	self * (@@currencies[b] / @@currencies[a])
  end

  def fetchRate(from_curr , to_curr)
	require "open-uri"
	url = "https://rate-exchange.appspot.com/currency?" + "from=" + @@change[from_curr] + "&to=" + @@change[to_curr] + "&q=" + self.to_s
	data = open(url).read
	data = data.split(' ')
	data
  end

  def exchange_currencyApi(from_curr , to_curr)		
	f1 = File.open("./Cashe.txt" , "r")
	day = f1.gets

	if day.to_i != Time.now.day
		f1.close
		data = fetchRate(from_curr , to_curr)
		f1 = File.open("./Cashe.txt" , "w")
		f1.puts Time.now.day
		f1.puts @@change[from_curr] + " " + @@change[to_curr] 
		f1.puts data[3][0...(data.length-1)];
		f1.close
		puts data[7][0...(data.length-2)].to_f;
	else
		while(line = f1.gets)
			a = @@change[from_curr] + " " + @@change[to_curr] + "\n";
			if(line.to_s == a)
				rate = f1.gets
				puts rate.to_f * self
				return
			end
		end
		f1.close
		f1 = File.open("./Cashe.txt" , 'a+')
		data = fetchRate(from_curr , to_curr)
		f1.puts @@change[from_curr] + " " + @@change[to_curr] 
		f1.puts data[3][0...(data.length-1)];
		f1.close
		puts data[7][0...(data.length-2)].to_f;
	end
  end

  @@currencies.each do |currency, rate|
    define_method(currency) do
      self * rate
    end
 	
    alias_method "#{currency}s".to_sym, currency
 	end
end
Numeric.add_currency(saudi_riyal: 1.9)
puts Numeric.currencies
puts 100.convert_currency( :egps , :dollars)
4.exchange_currencyApi( :dollar , :euro );


