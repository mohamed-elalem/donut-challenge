class Slack::Chain
  def initialize
    @head = nil
  end

  def with(chainable_klass)
    chainable = chainable_klass.new
    if @head.nil?
      @head = @cur = chainable
    else
      @cur.set_next(chainable)
      @cur = chainable
    end

    self
  end

  def end
    @cur.set_next(Slack::End.new)
    self
  end

  def handle(params)
    @head.handle(params)
  end
end