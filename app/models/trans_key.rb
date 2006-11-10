class TransKey < ActiveRecord::Base
  attr_accessor :value, :lang
  has_many :trans_values, :foreign_key=>'key_id'
  
  class << self
    def translate(keyword)
      key = TransKey.find_by_key(keyword)
      unless key
        key = TransKey.create(:key=>keyword)
      end
      key
    end
  end
  
  def into(la)
    val = self.trans_values.find(:first,
                    :select=>"*, (lang = '#{la.gsub(/[^\w]/,'')}') as lang_ok, (lang = '#{ZENA_ENV[:default_lang]}') as def_lang",
                    :order=>"lang_ok DESC, def_lang DESC")
    val = val ? val[:value] : self[:key]
  end
  
  def set(la,value)
    val = self.trans_values.find_by_lang(la) || TransValue.new(:lang=>la, :key_id=>self[:id])
    val[:value] = value
    val.save
  end
  
  def size
    trans_values.size
  end
end