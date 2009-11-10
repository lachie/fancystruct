class FancyStruct  
  
  ## class constuctors
  
  def self.create(*attribs, &blk)
    c = Class.new(FancyStruct)
    c.attribs *attribs
    c.class_eval(&blk) if blk
    c
  end
  
  ## object constructors
  
  def self.obj(hsh)
    keys, values = hsh.to_a.transpose
    FancyStruct(*keys).new(*values)
  end
  
  def self.deep_obj(obj)
    case obj
    when Array
      obj.map {|e| FancyStruct.deep_obj(e)}
    when Hash
      FancyStruct.obj( obj.each do |k,v|
        obj[k] = FancyStruct.deep_obj(v)
      end )
    else
      obj
    end
  end
  
  ## the class
  
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
    FancyStruct.deep_obj attribs.first
  else
    FancyStruct.create *attribs, &blk
  end
end