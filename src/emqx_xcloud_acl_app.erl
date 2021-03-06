%% Copyright (c) 2018 EMQ Technologies Co., Ltd. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(emqx_xcloud_acl_app).

-behaviour(application).

-include("emqx_xcloud_acl.hrl").

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    emqx_logger:error("Plugin xcloud acl started ..."),
    {ok, Sup} = emqx_xcloud_acl_sup:start_link(),
 %%   if_cmd_enabled(auth_cmd, fun reg_authmod/1),
    if_cmd_enabled(acl_cmd2,  fun reg_aclmod/1),
  %%  emqx_auth_redis_cfg:register(),
    {ok, Sup}.

stop(_State) ->
  %%  emqx_access_control:unregister_mod(auth, emqx_auth_redis),
    emqx_access_control:unregister_mod(acl, emqx_xcloud_acl).
  %%  emqx_auth_redis_cfg:unregister().

reg_aclmod(AclCmd) ->
    emqx_logger:error("reg_aclmod AclCmd:~w", [AclCmd]),
    emqx_access_control:register_mod(acl, emqx_xcloud_acl, AclCmd).

if_cmd_enabled(Par, Fun) ->
    emqx_logger:error("if_cmd_enabled Par:~w", [Par]),
    emqx_logger:error("application:get_env output:~w", [application:get_env(?APP, Par)]),
    emqx_logger:error("application:get_env all output:~w", [application:get_env(?APP)]),
emqx_logger:error("application:get_env all-all output:~w", [application:get_all_env()]),
    case application:get_env(?APP, Par) of
        {ok, Cmd} -> Fun(Cmd);
        undefined -> ok
    end.

