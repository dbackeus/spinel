# `system(cmd)` as the last expression of a method: the method's value is the
# command's exit status as a boolean. The statement form of system is a
# compound (it builds the argv array inside braces) whose value is void, so a
# tail system ran the command and the method fell through to its default
# return, false whatever the exit status; assigning the result to a local
# first worked. The block tail already carried the value (#4802). Common in
# thin wrappers around a CLI: `def kubectl(args) = system("kubectl #{args}")`.
def ok
  system "true"
end

def failing
  system "false"
end

def assigned
  r = system "true"
  r
end

p ok
p failing
p assigned

def endless_ok = system("true")
def endless_failing = system("false")
p endless_ok
p endless_failing

def argv_form
  system "echo", "argv form"
end
p argv_form

def interpolated(cmd)
  puts "running #{cmd}"
  system "#{cmd} > /dev/null"
end
p interpolated("true")
p interpolated("false")

def branch(flag)
  if flag
    system "true"
  else
    system "false"
  end
end
p branch(true)
p branch(false)

def guarded(flag)
  return false unless flag
  system "true"
end
p guarded(true)
p guarded(false)

class Runner
  def initialize(cmd) = @cmd = cmd
  def run
    system @cmd
  end
  def self.run(cmd)
    system cmd
  end
end
p Runner.new("true").run
p Runner.new("false").run
p Runner.run("true")

def check(cmd)
  system cmd
end
puts(check("true") ? "found" : "missing")
abort "not reached" unless check("true")
puts "guard passed"
p [check("true"), check("false")]

# the tail of a begin/rescue body and of an ensure'd body
def rescued
  system "true"
rescue StandardError
  false
end
p rescued

def ensured
  system "false"
ensure
  puts "ensure ran"
end
p ensured
