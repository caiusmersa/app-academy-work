def super_print(string, options = {})
  defaults = {
    :times => 2,
    :upcase => true,
    :reverse => true
  }
  defaults.merge!(options)
  string.upcase! if defaults[:upcase]
  string.reverse! if defaults[:reverse]
  options[:times].times { puts string }
end

super_print("testing", { times: 3, upcase: true })
