package com.creeperusa.spawnbiome;

import org.bukkit.Bukkit;
import org.bukkit.Location;
import org.bukkit.NamespacedKey;
import org.bukkit.World;
import org.bukkit.block.Biome;
import org.bukkit.command.Command;
import org.bukkit.command.CommandSender;
import org.bukkit.plugin.java.JavaPlugin;

import java.util.Locale;

public final class SpawnBiomePlugin extends JavaPlugin {

    @Override
    public void onEnable() {
        getLogger().info("SpawnBiome enabled.");
    }

    @Override
    public void onDisable() {
        getLogger().info("SpawnBiome disabled.");
    }

    @Override
    public boolean onCommand(CommandSender sender, Command command, String label, String[] args) {
        if (!command.getName().equalsIgnoreCase("spawnbiome")) {
            return false;
        }

        World world = resolveWorld(args);
        if (world == null) {
            sender.sendMessage("SPAWN_BIOME|ERROR|WORLD_NOT_FOUND");
            return true;
        }

        Location spawn = world.getSpawnLocation();
        Biome biome = spawn.getBlock().getComputedBiome();
        NamespacedKey key = biome.getKeyOrThrow();

        String biomeId = key.getNamespace() + ":" + key.getKey();
        String prettyName = toPrettyName(key.getKey());

        sender.sendMessage(
                "SPAWN_BIOME"
                        + "|" + biomeId
                        + "|" + prettyName
                        + "|" + world.getName()
                        + "|" + spawn.getBlockX()
                        + "|" + spawn.getBlockY()
                        + "|" + spawn.getBlockZ()
        );

        return true;
    }

    private World resolveWorld(String[] args) {
        if (args != null && args.length >= 1 && args[0] != null && !args[0].trim().isEmpty()) {
            return Bukkit.getWorld(args[0].trim());
        }

        if (Bukkit.getWorlds().isEmpty()) {
            return null;
        }

        return Bukkit.getWorlds().get(0);
    }

    private String toPrettyName(String key) {
        String[] parts = key.toLowerCase(Locale.ROOT).split("_");
        StringBuilder sb = new StringBuilder();

        for (String part : parts) {
            if (part.isEmpty()) {
                continue;
            }

            if (sb.length() > 0) {
                sb.append(' ');
            }

            sb.append(Character.toUpperCase(part.charAt(0)));

            if (part.length() > 1) {
                sb.append(part.substring(1));
            }
        }

        return sb.toString();
    }
}
