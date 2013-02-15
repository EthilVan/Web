module EthilVan

   class Role

      attr_reader :id, :name

      def initialize(id, data)
         @id = id.to_sym
         @name = data['name']
         @subroles = data['subroles'].map &:to_sym
      end

      def inherit?(role)
         self == role or strict_inherit?(role)
      end

      def strict_inherit?(role)
         @subroles.any? { |subrole_id| subrole_id == role.id }
      end

      @roles = EthilVan.load_data('misc', 'roles').map do |id, data|
         Role.new(id, data)
      end

      def self.get(id)
         @roles.find { |role| role.id == id}
      end

      def self.ids
         @roles.map &:id
      end

      ADMIN = get :admin
      MODO = get :modo
      REDACTEUR = get :redacteur
      MEMBER = get :default

      GUEST = Object.new
      def GUEST.id
         :guest
      end
      def GUEST.inherit?(role)
         role == self
      end
   end
end
