use std::collections::BTreeMap;
use zellij_tile::prelude::*;

#[derive(Default)]
struct State {
    yazi_id: Option<PaneId>,
    terminal_id: Option<PaneId>,
    setup_done: bool,
    yazi_hidden: bool,
    terminal_hidden: bool,
    is_controller: bool,
}

register_plugin!(State);

impl ZellijPlugin for State {
    fn load(&mut self, configuration: BTreeMap<String, String>) {
        if let Some(mode) = configuration.get("mode") {
            if mode == "controller" {
                self.is_controller = true;
            }
        }

        request_permission(&[
            PermissionType::ReadApplicationState,
            PermissionType::ChangeApplicationState,
            PermissionType::RunCommands,
            PermissionType::Reconfigure,
        ]);
        subscribe(&[
            EventType::PermissionRequestResult,
            EventType::PaneUpdate,
        ]);
    }

    fn update(&mut self, event: Event) -> bool {
        match event {
            Event::PermissionRequestResult(_) => {
                if !self.setup_done {
                    self.setup_done = true;
                    if self.is_controller {
                        self.initial_binds();
                        hide_self();
                    } else {
                        self.launch_layout();
                    }
                }
            }
            Event::PaneUpdate(manifest) => {
                if self.is_controller {
                    for (_tab_id, panes) in manifest.panes {
                        for pane in panes {
                            let pid = PaneId::Terminal(pane.id);
                            if pane.title == "Yazi" {
                                self.yazi_id = Some(pid);
                            } else if pane.title == "Terminal" {
                                self.terminal_id = Some(pid);
                            }
                        }
                    }
                }
            }
            _ => {}
        }
        false
    }

    fn pipe(&mut self, pipe_message: PipeMessage) -> bool {
        if let Some(payload) = pipe_message.payload {
            match payload.as_str() {
                "toggle_yazi" => {
                    if let Some(id) = self.yazi_id {
                        if self.yazi_hidden {
                            show_pane_with_id(id, true);
                            toggle_pane_embed_or_eject_for_pane_id(id);
                            // Tune Resize:
                            // Yazi loop: 20 was too much? 15?
                            // Let's try 12 to be safe.
                            for _ in 0..12 {
                                resize_focused_pane_with_direction(Resize::Decrease, Direction::Right);
                            }
                        } else {
                            hide_pane_with_id(id);
                        }
                        self.yazi_hidden = !self.yazi_hidden;
                    }
                }
                "toggle_terminal" => {
                    if let Some(id) = self.terminal_id {
                        if self.terminal_hidden {
                            show_pane_with_id(id, true);
                            toggle_pane_embed_or_eject_for_pane_id(id);
                            // Terminal loop: 10 was WAY too much (became tiny).
                            // Try 3.
                            for _ in 0..3 {
                                resize_focused_pane_with_direction(Resize::Decrease, Direction::Up);
                            }
                        } else {
                            hide_pane_with_id(id);
                        }
                        self.terminal_hidden = !self.terminal_hidden;
                    }
                }
                _ => {}
            }
        }
        false
    }
}

impl State {
    fn launch_layout(&mut self) {
        let layout = r#"
            layout {
                default_tab_template {
                    children
                    pane size=1 borderless=true {
                        plugin location="zjstatus"
                    }
                }
                tab name="IDE" focus=true {
                    pane split_direction="vertical" {
                        pane size="15%" command="yazi" name="Yazi" {
                            args "yazi_pwd"
                        }
                        pane split_direction="Horizontal" {
                            pane command="hx" name="helix" {
                                focus true
                            }
                            pane command="nu" name="Terminal" size="25%"
                        }
                    }
                    pane size=1 borderless=true {
                        plugin location="file:/home/gence/.dotfiles/zellij/zide-plugin/target/wasm32-wasip1/release/zide_plugin_v12.wasm" {
                            mode "controller"
                        }
                    }
                }
            }
        "#;
        new_tabs_with_layout(layout);
        close_focused_tab(); 
    }

    fn initial_binds(&mut self) {
        let my_plugin_id = get_plugin_ids().plugin_id;
        let config = format!(r#"
            keybinds {{
                shared {{
                    bind "Alt e" {{
                        MessagePluginId {} {{
                            payload "toggle_yazi"
                        }}
                    }}
                    bind "Alt t" {{
                        MessagePluginId {} {{
                            payload "toggle_terminal"
                        }}
                    }}
                }}
            }}
        "#, my_plugin_id, my_plugin_id);
        reconfigure(config, false);
    }
}

#[no_mangle]
pub extern "C" fn _start() {}
