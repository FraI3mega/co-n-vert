use color_eyre::eyre::{Ok, Result};
use regex::Regex;
use std::fs;
fn main() -> Result<()> {
    color_eyre::install()?;
    println!("Hello, world!");

    let re = Regex::new(r"^G1 X\d*\.(\d*) Y\d*\.(\d*) E\d*\.(\d*)$")?;

    let mut file = fs::read_to_string("test-reduced.gcode")?;
    println!("{}", file.lines().filter(|line| re.is_match(line)).count());
    for line in file.lines().filter(|line| re.is_match(line)) {
        println!("{line}");
    }
    Ok(())
}
