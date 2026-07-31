class MovimentacaoEstoque < ApplicationRecord
  belongs_to :produto
  belongs_to :usuario_administrativo, optional: true
  belongs_to :origem, polymorphic: true, optional: true

  validates :tipo, :motivo, presence: true
  validates :quantidade_anterior, :quantidade_nova,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
