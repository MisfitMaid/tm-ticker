/*
 * Copyright (c) 2023 MisfitMaid <misfit@misfitmaid.com>
 * Use of this source code is governed by the MIT license, which
 * can be found in the LICENSE file.
 */

namespace Ticker {

        TaskbarProvider@[] taskbarProviders;
        bool registerTaskbarProviderAddon(TaskbarProvider@ provider) {
            if (hasTaskbarProvider(provider.getID())) return false;

            taskbarProviders.InsertLast(provider);
            return true;
        }

        bool hasTaskbarProvider(const string &in identifier) {
            for (uint i = 0; i < taskbarProviders.Length; i++) {
                if (taskbarProviders[i].getID() == identifier) {
                    return true;
                }
            }
            return false;
        }

        TaskbarProvider@ getTaskbarProvider(const string &in identifier) {
            for (uint i = 0; i < taskbarProviders.Length; i++) {
                if (taskbarProviders[i].getID() == identifier) {
                    return taskbarProviders[i];
                }
            }
            throw("Could not find provider, please check with hasProvider() first!");
            NullTaskbar thisShouldntEverHappenButItWontCompile;
            return thisShouldntEverHappenButItWontCompile;
        }

        TaskbarProvider@[]@ getAllTaskbarProviders() {
            return taskbarProviders;
        }



        TickerItemProvider@[] itemProviders;
        bool registerTickerItemProviderAddon(TickerItemProvider@ provider) {
            if (hasTickerItemProvider(provider.getID())) return false;

            itemProviders.InsertLast(provider);
            return true;
        }

        bool hasTickerItemProvider(const string &in identifier) {
            for (uint i = 0; i < itemProviders.Length; i++) {
                if (itemProviders[i].getID() == identifier) {
                    return true;
                }
            }
            return false;
        }

        TickerItemProvider@ getTickerItemProvider(const string &in identifier) {
            for (uint i = 0; i < itemProviders.Length; i++) {
                if (itemProviders[i].getID() == identifier) {
                    return itemProviders[i];
                }
            }
            throw("Could not find provider, please check with hasProvider() first!");
            NullTickerItemProvider thisShouldntEverHappenButItWontCompile;
            return thisShouldntEverHappenButItWontCompile;
        }

        TickerItemProvider@[]@ getAllTickerItemProviders() {
            return itemProviders;
        }


}
