CREATE MIGRATION m1nffppd5l4ktownrxmf4dnlqj77jwuqqp2n2l5wc7g4ynwys7gh3a
    ONTO initial
{
  CREATE FUTURE nonrecursive_access_policies;
  CREATE TYPE default::InsertTest {
      CREATE REQUIRED PROPERTY source -> std::str;
      CREATE REQUIRED PROPERTY timestamp -> std::datetime;
  };
};
