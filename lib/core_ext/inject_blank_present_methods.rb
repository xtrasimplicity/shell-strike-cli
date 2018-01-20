class String
  def blank?
    empty? || (self.gsub(/\s/,'').length == 0)
  end
  
  def present?
    !blank?
  end
end