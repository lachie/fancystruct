require 'exemplor'

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
  end
  
  def set_attrib(name,val)
    self.send(name.to_s+'=', val)
  end
  
end

def FancyStruct(*attribs, &blk)
  c = Class.new(FancyStruct)
  c.attribs *attribs
  c.class_eval(&blk) if blk
  c
end

eg.helpers do
  
  def fn; "Myles" end
  def ln; "Byrne" end
  def em; "myles@myles.id.au" end
  
  def set_attribs(fs)
    fs.first_name = fn
    fs.last_name  = ln
  end
  
  def check_fancystruct(fs)
    Check(fs.first_name).is(fn)
    Check(fs.last_name).is(ln)
  end
  
end

eg "the FancyStruct method returns a class" do
  cls = FancyStruct :first_name, :last_name, :email
  fs = cls.new
  set_attribs fs
  check_fancystruct fs
end

eg "takes a block for method definitions and such" do
  cls = FancyStruct :first_name, :last_name, :email do
    def full_name
      first_name + ' ' + last_name
    end
  end
  fs = cls.new
  set_attribs fs
  check_fancystruct fs
end

eg "the .new factory sets attributes via a single hash" do
  cls = FancyStruct :first_name, :last_name, :email
  fs = cls.new :first_name => fn, :last_name => ln, :email => em
  check_fancystruct fs
end

eg "the .new factory sets attributes via an array of values" do
  cls = FancyStruct :first_name, :last_name, :email
  fs = cls.new fn, ln, em
  check_fancystruct fs
end

class Person < FancyStruct :first_name, :last_name, :email
  
  def full_name
    first_name + ' ' + last_name
  end
  
end

eg "can be declared with class-like syntax (plain old inheritance)" do
  p = Person.new
  set_attribs p
  check_fancystruct p
end