#!/usr/bin/env nu

def main [] {
  let root = pwd | path dirname

  ls $"($root)/hooks" | where name !~ .nu | each {
    let src = $in.name
    let dst = $"($root)/.git/hooks/($in.name | path basename)"
    if ($dst | path exists) {
      print $"Removing old ($dst)"
      rm $dst
    }
    print $"Linking ($src) -> ($dst)"
    ln -s $src $dst
  }

  return
}

