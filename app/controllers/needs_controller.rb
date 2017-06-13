class NeedsController < ApplicationController

    def index
        @needs = Need.all.to_a
    end

end
