class Array
  def reject_blank
    reject { |x| x.nil? || x.length == 0 || x.to_s.blank? }
  end
end