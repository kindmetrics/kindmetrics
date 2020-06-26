module KindEnv
  extend self

  def env(key : String)
    ENV[key]?.try(&.strip)
  end

end
