Postgrex.Types.define(PersonnelServer.PostgrexTypes,
    [PersonnelServer.LTree, PersonnelServer.Lquery] ++ Ecto.Adapters.Postgres.extensions(), [decode_binary: :copy, json: Poison])