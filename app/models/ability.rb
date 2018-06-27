class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? :admin
      can :manage, :all

    elsif user.role? :worker
      can :read, User do |u|
        u.id == user.id
      end
      can :update, User do |u|
        u.id == user.id
      end

      can :manage, Camps do |c|
        a.all_org_ids.include?(user.organization_id)
      end
      
      can :read, Organization do |o|
        o.id == user.organization_id
      end
      can :read, Alliance do |a|
        a.all_org_ids.include?(user.organization_id)
      end
      can :manage, Post do |p|
        alliance_ids = p.sharings.map(&:alliance_id)
        org_allies = user.organization.all_alliance_ids
        p.poster.organization_id ==user.organization_id or ((alliance_ids & org_allies) != [])
      end
      # can :manage, Post
    else
      can :create, User
    end

    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
