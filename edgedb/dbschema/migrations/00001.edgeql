CREATE MIGRATION m166anjrwy3qz7s7w6sbnr6752votmvz6g46utnyghwjw43rjtyhdq
    ONTO initial
{
  CREATE TYPE default::InsertTest {
      CREATE REQUIRED PROPERTY source -> std::str;
      CREATE REQUIRED PROPERTY timestamp -> std::datetime;
  };
};
