class ApplicationPolicy
  attr_reader :usuario, :registro

  def initialize(usuario, registro)
    @usuario = usuario
    @registro = registro
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :usuario, :scope

    def initialize(usuario, scope)
      @usuario = usuario
      @scope = scope
    end

    def resolve
      scope.none
    end
  end
end
