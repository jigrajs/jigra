package com.getjigra.plugin;

import com.getjigra.NativePlugin;
import com.getjigra.Plugin;
import com.getjigra.PluginCall;
import com.getjigra.PluginMethod;

@NativePlugin()
public class Photos extends Plugin {

  @PluginMethod()
  public void getAlbums(PluginCall call) {
    call.unimplemented();
  }

  @PluginMethod()
  public void getPhotos(PluginCall call) {
    call.unimplemented();
  }

  @PluginMethod()
  public void createAlbum(PluginCall call) {
    call.unimplemented();
  }

  @PluginMethod()
  public void savePhoto(PluginCall call) {
    call.unimplemented();
  }
}
