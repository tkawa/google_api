module GoogleApi
  class ShortenMapper
    include Shorten

    def initialize(session)
      @session = session
      super()
    end

    def insert(url)
      InsertMapper.new(@session, url)
    end

    # not implement yet
    #def list
    #  ListMapper.new(@session)
    #end
    #
    #def get(url, projection = 'FULL')
    #  GetMapper.new(@session, url, projection)
    #end

  end
end
