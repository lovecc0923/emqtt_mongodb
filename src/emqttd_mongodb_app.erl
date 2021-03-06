-module(emqttd_mongodb_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
%% 	{ok, Database}  = application:get_env(?MODULE, database),
%% 	{ok, Collection}  = application:get_env(?MODULE, collection),
%% 	{ok, HashType} = application:get_env(?MODULE, password_hash),
  application:start(bson),
  application:start(crypto),
  application:start(mongodb),
  ok = emqttd_access_control:register_mod(auth, emqttd_auth_mongodb, {<<"db0">>, <<"UserAccount">>, sha256}),
  Env = application:get_all_env(),
  emqttd_mongodb:onload(Env),
  emqttd_mongodb_sup:start_link().

stop(_State) ->
  application:stop(mongodb),
  application:stop(crypto),
  application:stop(bson),
  emqttd_mongodb:onunload(), ok.
