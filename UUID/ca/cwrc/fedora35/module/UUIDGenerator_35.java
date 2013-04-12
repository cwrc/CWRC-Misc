/**
 * Addapted by CWRC (cwrc.ca) for use with Fedora 3.5
 * Originally created by:
 *
 * University of Alberta Libraries
 * Information Technology and Services
 * Project: ir
 * UUIDGenerator for Fedora Commons 3.5 PIDs
 */
package ca.cwrc.fedora35.module;

import java.io.IOException;
import java.util.Map;
import java.util.UUID;

import org.fcrepo.common.PID;
import org.fcrepo.server.Module;
import org.fcrepo.server.Server;
import org.fcrepo.server.errors.ModuleInitializationException;
import org.fcrepo.server.management.PIDGenerator;

/**
 * The UUIDGenerator class.
 * 
 */
public class UUIDGenerator_35 extends Module implements PIDGenerator {
        private String neverGeneratePID;
        private PID lastPID;

        /**
         * The UUIDGenerator class constructor.
         * 
         * @param moduleParameters
         * @param server
         * @param role
         * @throws ModuleInitializationException
         */
        @SuppressWarnings("unchecked")
        public UUIDGenerator_35(Map moduleParameters, Server server, String role) throws ModuleInitializationException {
                super(moduleParameters, server, role);
        }

        /**
         * 
         * @see fedora.server.management.PIDGenerator#generatePID(java.lang.String)
         */
        public PID generatePID(String namespace) throws IOException {
                String pidValue = namespace + ":" + UUID.randomUUID().toString();
                PID pid = pidValue.equals(neverGeneratePID) ? null : PID.getInstance(pidValue);
                lastPID = pid == null ? lastPID : pid;
                return pid;
        }

        /**
         * 
         * @see fedora.server.management.PIDGenerator#getLastPID()
         */
        public PID getLastPID() throws IOException {
                return lastPID;
        }

        /**
         * 
         * @see fedora.server.management.PIDGenerator#neverGeneratePID(java.lang.String)
         */
        public void neverGeneratePID(String pid) throws IOException {
                neverGeneratePID = pid;
        }

}
