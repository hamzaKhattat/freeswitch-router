// include/freeswitch/fs_xml_generator.h
#ifndef FS_XML_GENERATOR_H
#define FS_XML_GENERATOR_H

// Original functions
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

// Module 2 specific functions
int fs_generate_module2_route_dialplan(void);
int fs_generate_corrected_lua_handler(void);
int fs_remove_route_dialplan(const char *route_id);
int fs_clear_dialplan_cache(void);
int fs_restore_dialplans_from_cache(void);

#endif
