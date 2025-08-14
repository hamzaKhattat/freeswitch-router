#ifndef FS_XML_GENERATOR_H
#define FS_XML_GENERATOR_H

int fs_init_all_directories(void);
int fs_generate_main_config(void);
int fs_generate_sip_profiles(void);
int fs_generate_dialplan_contexts(void);
int fs_generate_autoload_configs(void);
int fs_generate_provider_config(const char *uuid, const char *name, 
                              const char *host, int port, const char *role,
                              int auth_type, const char *auth_data);
int fs_remove_provider_config(const char *uuid, const char *role);
int fs_regenerate_all_providers(void);
int fs_generate_route_dialplan(void);
int fs_generate_route_handler_lua(void);
int fs_reload_config(void);
int fs_generate_complete_config(void);

#endif
