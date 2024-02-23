function manipulators(): Array<Mapping> {
  return [
    // movement
    bindCaps("h", press("left_arrow")),
    bindCaps("j", press("down_arrow")),
    bindCaps("k", press("up_arrow")),
    bindCaps("l", press("right_arrow")),
    bindCaps("a", press("home")),
    bindCaps("g", press("end")),

    // umlauts
    bind(["a", "s", "d"], umlaut("a")),
    bind(["k", "l", "semicolon"], umlaut("o")),
    bind(["i", "o", "p"], umlaut("u")),
    bind(["s", "d", "f"], [press("s", ["left_option"]), press("vk_none")]),

    bind(["j", "l"], press("delete_or_backspace", ["left_option"])),

    bindCaps("d", press("9", ["shift"])),
    bindCaps("f", press("0", ["shift"])),
    bindCaps("u", press("open_bracket", ["shift"])),
    bindCaps("p", press("close_bracket", ["shift"])),
    bindCaps("i", press("open_bracket")),
    bindCaps("o", press("close_bracket")),
    bindCaps("x", press("delete_forward")),
    bindCaps("n", press("delete_or_backspace")),
    bindCaps("r", press("slash")),
    bindCaps("t", press("backslash")),
    bindCaps("e", press("quote", ["shift"])),
    bindCaps("semicolon", press("7", ["shift"])),
    bindCaps("quote", press("5", ["shift"])),
    {
      from: from("caps_lock"),
      to: setVariable("caps_lock pressed", 1),
      to_after_key_up: setVariable("caps_lock pressed", 0),
      to_if_alone: [press("escape")],
      type: "basic",
    },
  ];
}

function fn_function_keys(): Array<Mapping> {
  return [
    bind("f1", toConsumer("display_brightness_decrement")),
    bind("f2", toConsumer("display_brightness_increment")),
    bind("f3", toApple("mission_control")),
    bind("f4", toApple("spotlight")),
    bind("f5", toConsumer("dictation")),
    bind("f6", press("f6")),
    bind("f7", toConsumer("rewind")),
    bind("f8", toConsumer("play_or_pause")),
    bind("f9", toConsumer("fast_forward")),
    bind("f10", toConsumer("mute")),
    bind("f11", toConsumer("volume_decrement")),
    bind("f12", toConsumer("volume_increment")),
  ];
}

function generate() {
  const rules = [{
    description: "CAPSLOCK + hjkl to arrow keys",
    manipulators: manipulators(),
  }];
  return {
    global: {
      ask_for_confirmation_before_quitting: true,
      check_for_updates_on_startup: true,
      show_in_menu_bar: true,
      show_profile_name_in_menu_bar: false,
      unsafe_ui: false,
    },
    profiles: [
      {
        complex_modifications: {
          parameters: {
            "basic.simultaneous_threshold_milliseconds": 50,
            "basic.to_delayed_action_delay_milliseconds": 500,
            "basic.to_if_alone_timeout_milliseconds": 1000,
            "basic.to_if_held_down_threshold_milliseconds": 500,
            "mouse_motion_to_scroll.speed": 100,
          },
          rules,
        },
        fn_function_keys: fn_function_keys(),
        indicate_sticky_modifier_keys_state: true,
        mouse_key_xy_scale: 100,
        name: "Default profile",
        parameters: { delay_milliseconds_before_open_device: 1000 },
        selected: true,
        simple_modifications: [],
        virtual_hid_keyboard: {
          country_code: 0,
          indicate_sticky_modifier_keys_state: true,
          mouse_key_xy_scale: 100,
        },
        devices: [],
      },
    ],
  };
}

console.log(JSON.stringify(generate(), null, 2));

// Helpers and types

type Condition = { name: string; type: string; value: number };

type From =
  | { key_code: string; modifiers: { optional: string[] } }
  | { simultaneous: { key_code: string }[]; modifiers: { optional: string[] } };

type ToAction =
  | { key_code: string; modifiers?: string[] }
  | { consumer_key_code: string; modifiers?: string[] }
  | { apple_vendor_keyboard_key_code: string; modifiers?: string[] }
  | { set_variable: { name: string; value: number } };
type To = Array<ToAction>;

type Mapping = {
  conditions?: Condition[];
  from: From;
  to: To;
  to_after_key_up?: To;
  to_if_alone?: To;
  type: "basic";
};

function from(key: string | string[], optional: string[] = ["any"]): From {
  if (typeof key === "string") {
    return { key_code: key, modifiers: { optional } };
  } else if (Array.isArray(key)) {
    return {
      simultaneous: key.map((x) => ({ key_code: x })),
      modifiers: { optional },
    };
  } else {
    throw new Error("Invalid key type");
  }
}

function umlaut(letter: string): To {
  return [
    press("u", ["left_option"]),
    press(letter),
    press("vk_none"),
  ];
}

function press(key: string, mods: string[] = []): ToAction {
  return { key_code: key, modifiers: mods };
}

function toConsumer(key: string): To {
  return [{ consumer_key_code: key }];
}

function toApple(key: string): To {
  return [{ apple_vendor_keyboard_key_code: key }];
}

function bind(
  f: string | string[],
  to: ToAction | To,
  when: Condition[] = [],
): Mapping {
  const toValue = Array.isArray(to) ? to : [to];
  return { conditions: when, from: from(f), to: toValue, type: "basic" };
}

function bindCaps(from: string | string[], to: ToAction | To): Mapping {
  const capsCondition: Condition = {
    name: "caps_lock pressed",
    type: "variable_if",
    value: 1,
  };
  return bind(from, to, [capsCondition]);
}

function setVariable(name: string, value: number): To {
  return [{ set_variable: { name, value } }];
}
