#!/bin/bash
set -e

podman=`which podman || true`

if [ -z $podman ]; then
  echo "podman needs to be in PATH for this script to work."
  exit 1
fi

cd ../..

project_root=$(pwd)/
img_version=pe

slim_custom_args="disable_3d=yes module_bmp_enabled=no module_broken_seals_module_enabled=no module_cscript_enabled=no module_cvtt_enabled=no module_database_enabled=no module_dds_enabled=no module_enet_enabled=no module_entity_spell_system_enabled=no module_fastnoise_enabled=no module_hdr_enabled=no module_http_server_simple_enabled=no module_jpg_enabled=no module_material_maker_enabled=no module_mesh_data_resource_enabled=no module_mesh_utils_enabled=no module_minimp3_enabled=no module_network_synchronizer_enabled=no module_ogg_enabled=no module_opensimplex_enabled=no module_opus_enabled=no module_props_enabled=no module_props_2d_enabled=no module_pvr_enabled=no module_regex_enabled=no module_rtile_map_enabled=no module_skeleton_2d_enabled=no module_skeleton_3d_enabled=no module_squish_enabled=no module_stb_vorbis_enabled=no module_svg_enabled=no module_terraman_enabled=no module_terraman_2d_enabled=no module_texture_packer_enabled=no module_tga_enabled=no module_theora_enabled=no module_thread_pool_enabled=no module_ui_extensions_enabled=no module_upnp_enabled=no module_users_enabled=no module_vhacd_enabled=no module_vorbis_enabled=no module_voxelman_enabled=no module_web_enabled=no module_websocket_enabled=no module_wfc_enabled=no"
slim_custom_args_editor="module_gltf_enabled=no module_bmp_enabled=no module_broken_seals_module_enabled=no module_cscript_enabled=no module_cvtt_enabled=no module_database_enabled=no module_dds_enabled=no module_enet_enabled=no module_entity_spell_system_enabled=no module_fastnoise_enabled=no module_hdr_enabled=no module_http_server_simple_enabled=no module_jpg_enabled=no module_material_maker_enabled=no module_mesh_data_resource_enabled=no module_mesh_utils_enabled=no module_minimp3_enabled=no module_network_synchronizer_enabled=no module_ogg_enabled=no module_opensimplex_enabled=no module_opus_enabled=no module_props_enabled=no module_props_2d_enabled=no module_pvr_enabled=no module_rtile_map_enabled=no module_skeleton_2d_enabled=no module_skeleton_3d_enabled=no module_squish_enabled=no module_stb_vorbis_enabled=no module_terraman_enabled=no module_terraman_2d_enabled=no module_texture_packer_enabled=no module_tga_enabled=no module_theora_enabled=no module_thread_pool_enabled=no module_ui_extensions_enabled=no module_upnp_enabled=no module_users_enabled=no module_vhacd_enabled=no module_vorbis_enabled=no module_voxelman_enabled=no module_web_enabled=no module_websocket_enabled=no module_wfc_enabled=no"

mkdir -p logs

rm -f modules/modules_enabled.gen.h

# Windows editor (release debug) 64 bit
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-windows:${img_version} scons ${slim_custom_args_editor} custom_modules="./custom_modules"  tools=yes target=release_debug debug_symbols=no platform=windows bits=64 -j4 . 2>&1 | tee logs/windows_ed_64.log
rm -f modules/modules_enabled.gen.h
# Windows editor (release debug) 32 bit
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-windows:${img_version} scons ${slim_custom_args_editor} custom_modules="./custom_modules"  tools=yes target=release_debug debug_symbols=no platform=windows bits=32 -j4 . 2>&1 | tee logs/windows_ed_32.log
rm -f modules/modules_enabled.gen.h

# Windows templates 64 bit
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-windows:${img_version} scons ${slim_custom_args} custom_modules="./custom_modules"  tools=no target=release_debug custom_modules_shared=no debug_symbols=no platform=windows bits=64 -j4 . 2>&1 | tee logs/windows_template_rd_64.log
rm -f modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-windows:${img_version} scons ${slim_custom_args} custom_modules="./custom_modules"  tools=no target=release custom_modules_shared=no debug_symbols=no platform=windows bits=64 -j4 . 2>&1 | tee logs/windows_template_r_64.log
rm -f modules/modules_enabled.gen.h

# Windows templates 32 bit
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-windows:${img_version} scons ${slim_custom_args} custom_modules="./custom_modules"  tools=no target=release_debug custom_modules_shared=no debug_symbols=no platform=windows bits=32 -j4 . 2>&1 | tee logs/windows_template_rd_32.log
rm -f modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-windows:${img_version} scons ${slim_custom_args} custom_modules="./custom_modules"  tools=no target=release custom_modules_shared=no debug_symbols=no platform=windows bits=32 -j4 . 2>&1 | tee logs/windows_template_r_32.log
rm -f modules/modules_enabled.gen.h

# Linux editor 64 bit
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-linux:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args_editor} tools=yes target=release_debug custom_modules_shared=no debug_symbols=no platform=x11 bits=64 -j4 . 2>&1 | tee logs/linux_ed_64.log
rm -f modules/modules_enabled.gen.h

# Linux templates 64 bit
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-linux:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args} tools=no target=release_debug custom_modules_shared=no debug_symbols=no platform=x11 bits=64 -j4 . 2>&1 | tee logs/linux_template_rd_64.log
rm -f modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-linux:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args} tools=no target=release custom_modules_shared=no debug_symbols=no platform=x11 bits=64 -j4 . 2>&1 | tee logs/linux_template_r_64.log
rm -f modules/modules_enabled.gen.h

# Linux headless (editor) 64bit
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-linux:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args_editor} tools=yes target=release_debug custom_modules_shared=no debug_symbols=no platform=server bits=64 -j4 . 2>&1 | tee logs/headless.log
rm -f modules/modules_enabled.gen.h

# Linux server (templates) 64bit
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-linux:${img_version} scons ${slim_custom_args} custom_modules="./custom_modules"  tools=no target=release_debug custom_modules_shared=no debug_symbols=no platform=server bits=64 -j4 . 2>&1 | tee logs/server_rd.log
rm -f modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-linux:${img_version} scons ${slim_custom_args} custom_modules="./custom_modules"  tools=no target=release custom_modules_shared=no debug_symbols=no platform=server bits=64 -j4 . 2>&1 | tee logs/server_d.log
rm -f modules/modules_enabled.gen.h

# Javascript templates normal
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-javascript:${img_version} bash -c 'source /root/emsdk_3.1.14/emsdk_env.sh;scons custom_modules="./custom_modules" disable_3d=yes module_bmp_enabled=no module_broken_seals_module_enabled=no module_cscript_enabled=no module_cvtt_enabled=no module_database_enabled=no module_dds_enabled=no module_enet_enabled=no module_entity_spell_system_enabled=no module_fastnoise_enabled=no module_hdr_enabled=no module_http_server_simple_enabled=no module_jpg_enabled=no module_material_maker_enabled=no module_mesh_data_resource_enabled=no module_mesh_utils_enabled=no module_minimp3_enabled=no module_network_synchronizer_enabled=no module_ogg_enabled=no module_opensimplex_enabled=no module_opus_enabled=no module_props_enabled=no module_props_2d_enabled=no module_pvr_enabled=no module_regex_enabled=no module_rtile_map_enabled=no module_skeleton_2d_enabled=no module_skeleton_3d_enabled=no module_squish_enabled=no module_stb_vorbis_enabled=no module_svg_enabled=no module_terraman_enabled=no module_terraman_2d_enabled=no module_texture_packer_enabled=no module_tga_enabled=no module_theora_enabled=no module_thread_pool_enabled=no module_ui_extensions_enabled=no module_upnp_enabled=no module_users_enabled=no module_vhacd_enabled=no module_vorbis_enabled=no module_voxelman_enabled=no module_web_enabled=no module_websocket_enabled=no module_wfc_enabled=no tools=no target=release_debug custom_modules_shared=no debug_symbols=no platform=javascript -j4' . 2>&1 | tee logs/javascript_rd.log
rm -f modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-javascript:${img_version} bash -c 'source /root/emsdk_3.1.14/emsdk_env.sh;scons custom_modules="./custom_modules" disable_3d=yes module_bmp_enabled=no module_broken_seals_module_enabled=no module_cscript_enabled=no module_cvtt_enabled=no module_database_enabled=no module_dds_enabled=no module_enet_enabled=no module_entity_spell_system_enabled=no module_fastnoise_enabled=no module_hdr_enabled=no module_http_server_simple_enabled=no module_jpg_enabled=no module_material_maker_enabled=no module_mesh_data_resource_enabled=no module_mesh_utils_enabled=no module_minimp3_enabled=no module_network_synchronizer_enabled=no module_ogg_enabled=no module_opensimplex_enabled=no module_opus_enabled=no module_props_enabled=no module_props_2d_enabled=no module_pvr_enabled=no module_regex_enabled=no module_rtile_map_enabled=no module_skeleton_2d_enabled=no module_skeleton_3d_enabled=no module_squish_enabled=no module_stb_vorbis_enabled=no module_svg_enabled=no module_terraman_enabled=no module_terraman_2d_enabled=no module_texture_packer_enabled=no module_tga_enabled=no module_theora_enabled=no module_thread_pool_enabled=no module_ui_extensions_enabled=no module_upnp_enabled=no module_users_enabled=no module_vhacd_enabled=no module_vorbis_enabled=no module_voxelman_enabled=no module_web_enabled=no module_websocket_enabled=no module_wfc_enabled=no tools=no target=release custom_modules_shared=no debug_symbols=no platform=javascript -j4' . 2>&1 | tee logs/javascript_r.log
rm -f modules/modules_enabled.gen.h

# Android templates release_debug
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-android:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args} tools=no target=release_debug custom_modules_shared=no debug_symbols=no platform=android android_arch=armv7 -j4 . 2>&1 | tee logs/android_template_rd_armv7.log
rm -f modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-android:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args} tools=no target=release_debug custom_modules_shared=no debug_symbols=no platform=android android_arch=arm64v8 -j4 . 2>&1 | tee logs/android_template_rd_arm64v8.log
rm -f modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-android:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args} tools=no target=release_debug custom_modules_shared=no debug_symbols=no platform=android android_arch=x86 -j4 . 2>&1 | tee logs/android_template_rd_x86.log
rm -f modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-android:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args} tools=no target=release_debug custom_modules_shared=no debug_symbols=no platform=android android_arch=x86_64 -j4 . 2>&1 | tee logs/android_template_rd_x86_64.log
rm -f modules/modules_enabled.gen.h

$podman run -v ${project_root}:/root/project -w /root/project pandemonium-android:${img_version} bash -c 'cd platform/android/java/;./gradlew generatePandemoniumTemplates' . 2>&1 | tee logs/android_template_rd_assemble.log

# Android templates release
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-android:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args} tools=no target=release custom_modules_shared=no debug_symbols=no platform=android android_arch=armv7 -j4 . 2>&1 | tee logs/android_template_r_armv7.log
rm -f modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-android:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args} tools=no target=release custom_modules_shared=no debug_symbols=no platform=android android_arch=arm64v8 -j4 . 2>&1 | tee logs/android_template_r_arm64v8.log
rm -f modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-android:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args} tools=no target=release custom_modules_shared=no debug_symbols=no platform=android android_arch=x86 -j4 . 2>&1 | tee logs/android_template_r_x86.log
rm -f modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-android:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args} tools=no target=release custom_modules_shared=no debug_symbols=no platform=android android_arch=x86_64 -j4 . 2>&1 | tee logs/android_template_r_x86_64.log
rm -f modules/modules_enabled.gen.h

$podman run -v ${project_root}:/root/project -w /root/project pandemonium-android:${img_version} bash -c 'cd platform/android/java/;./gradlew generatePandemoniumTemplates' . 2>&1 | tee logs/android_template_r_assemble.log

# OSX editor
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-osx:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args_editor} tools=yes target=release_debug custom_modules_shared=no debug_symbols=no platform=osx arch=x86_64 -j4 osxcross_sdk=darwin20.4 . 2>&1 | tee logs/osx_editor_x86_64.log
rm -f modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-osx:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args_editor} tools=yes target=release_debug custom_modules_shared=no debug_symbols=no platform=osx arch=arm64 -j4 osxcross_sdk=darwin20.4 . 2>&1 | tee logs/sx_editor_arm64.log
rm -f modules/modules_enabled.gen.h

# OSX templates release_debug
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-osx:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args} tools=no target=release_debug custom_modules_shared=no debug_symbols=no platform=osx arch=x86_64 -j4 osxcross_sdk=darwin20.4 . 2>&1 | tee logs/osx_template_rd_x86_64.log
rm -f modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-osx:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args} tools=no target=release_debug custom_modules_shared=no debug_symbols=no platform=osx arch=arm64 -j4 osxcross_sdk=darwin20.4 . 2>&1 | tee logs/osx_template_rd_arm64.log
rm -f modules/modules_enabled.gen.h

# OSX templates release
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-osx:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args} tools=no target=release custom_modules_shared=no debug_symbols=no platform=osx arch=x86_64 -j4 osxcross_sdk=darwin20.4 . 2>&1 | tee logs/osx_template_r_x86_64.log
rm -f modules/modules_enabled.gen.h
$podman run -v ${project_root}:/root/project -w /root/project pandemonium-osx:${img_version} scons custom_modules="./custom_modules" ${slim_custom_args} tools=no target=release custom_modules_shared=no debug_symbols=no platform=osx arch=arm64 -j4 osxcross_sdk=darwin20.4 . 2>&1 | tee logs/osx_template_r_arm64.log
rm -f modules/modules_enabled.gen.h

# OSX lipo
$podman run -v ${project_root}:/root/project -w /root/project/misc/osx pandemonium-osx:${img_version} bash -c ./lipo.sh

#ios
#$podman run -v ${project_root}:/root/project -w /root/project pandemonium-ios:${img_version} scons bir_strip -j4 . 2>&1 | tee logs/bir.log
#rm -f modules/modules_enabled.gen.h

# $podman run -v ${project_root}:/root/project -i -w /root/project -t pandemonium-windows:${img_version} scons bew -j4
rm -f modules/modules_enabled.gen.h

# Check files

cd ./bin/

files=(
  # Windows
  "pandemonium.windows.opt.64.exe"
  "pandemonium.windows.opt.debug.64.exe"
  
  "pandemonium.windows.opt.32.exe"
  "pandemonium.windows.opt.debug.32.exe"

  "pandemonium.windows.opt.tools.64.exe"
  "pandemonium.windows.opt.tools.32.exe"

  # Linux
  "pandemonium.x11.opt.64"
  "pandemonium.x11.opt.debug.64"

  #"pandemonium.x11.opt.32"
  #"pandemonium.x11.opt.debug.32"

  "pandemonium.x11.opt.tools.64"
  #"pandemonium.x11.opt.tools.32"

  # Server (Linux) - template
  "pandemonium_server.x11.opt.64"
  "pandemonium_server.x11.opt.debug.64"

  # Headless (Linux) - editor

  "pandemonium_server.x11.opt.tools.64"

  # JS
  "pandemonium.javascript.opt.zip"
  "pandemonium.javascript.opt.debug.zip"

  "pandemonium.javascript.opt.threads.zip"
  "pandemonium.javascript.opt.debug.threads.zip"

  "pandemonium.javascript.opt.tools.threads.zip"

  # Android
  "android_source.zip"
  "android_debug.apk"
  "android_release.apk"
  "android_editor.apk"
  "pandemonium-lib.release.aar"

  # OSX
  "pandemonium.osx.opt.arm64"
  "pandemonium.osx.opt.universal"
  "pandemonium.osx.opt.x86_64"

  "pandemonium.osx.opt.debug.arm64"
  "pandemonium.osx.opt.debug.universal"
  "pandemonium.osx.opt.debug.x86_64"

  "pandemonium.osx.opt.tools.arm64"
  "pandemonium.osx.opt.tools.universal"
  "pandemonium.osx.opt.tools.x86_64"
)

error=0

for f in ${files[*]} 
do
if [ ! -e $f ]; then
  error=1
  echo "$f is not present!"
fi
done

if [ $error -eq 0 ]; then
  echo "All files are present!"
fi

cd ..
