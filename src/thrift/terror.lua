return function(e)
  if e and e.__tostring then
    error(e:__tostring())
    return
  end
  error(e)
end
