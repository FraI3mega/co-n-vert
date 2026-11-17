use color_eyre::eyre::{Ok, Result};
use std::fs;
fn main() -> Result<()> {
    color_eyre::install()?;
    println!("Hello, world!");
    Ok(())
}
