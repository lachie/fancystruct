class FancyStruct  
  
  def self.attribs(*attribs)
    @attribs ||= []
    unless attribs.empty?
      self.send :attr_accessor, *attribs
      @attribs += attribs 
    end
    @attribs
  end
  
  def initialize(*args)
    if args.size == 1 && args.first.is_a?(Hash)
      self.set(args.first)
    else
      self.class.attribs.each_with_index { |name, i| self.set_attrib(name, args[i]) if args[i] }
    end
  end
  
  def set(attribs)
    attribs.each { |name,val| self.set_attrib(name, val) }
    self
  end
  
  def set_attrib(name,val)
    self.send(name.to_s+'=', val)
  end
  
end

def FancyStruct(*attribs, &blk)
  if attribs.size == 1 && attribs.first.is_a?(Hash)
    keys, values = attribs.first.to_a.transpose
    FancyStruct(*keys).new(*values)
  else
    c = Class.new(FancyStruct)
    c.attribs *attribs
    c.class_eval(&blk) if blk
    c
  end
end