__author__ = 'zvikagutkin'


from cm_api.api_client import ApiResource
import argparse


class cm_utils(object):


    def __init__(self,service,role,host,list):
        self.service = service.lower()
        self.role = role.lower()
        self.host = host.lower()
	self.list = list.lower()
        cm_host = '10.7.177.234'
        self.api = ApiResource(cm_host, username="admin", password="fruitile4u#")
        # "ALL" if service == "None" else  service
        # "ALL" if role == "None" else role
        # "ALL" if host == "None" else host


    def main(self):

#
        s_filter = None
        for c in self.api.get_all_clusters():
            print c
            for s in c.get_all_services():
                print "SERVICE : " + s.displayName + "==============="
#                if (s.displayName.lower() == self.service) or (self.service == "all"):
                if ( self.service in s.displayName.lower() ) or (self.service == "all"):
                    s_filter = s
                    for r in s_filter.get_all_roles():
#                        print "ROLE : " + r.type + "================"
                        if (self.role in r.type.lower()) or (self.role == "all"):
                            h = r.hostRef.hostId
                            hostname,ipAddress,healthSummary = self._get_host_info(h)
                            if (self.host in hostname) or (self.host in ipAddress) or (self.host in h) or (self.host == "all"):
                                if self.list == "yes":
                                    print ipAddress
                                else:
                                    print "[" + r.type + "]" + hostname + " " + ipAddress + " " + healthSummary




    def _get_host_info(self,hostid):
        host = self.api.get_host(hostid)
#        self.hostname = host.hostname
#        self.host_ip = host.ipAddress
#        self.host_status = host.healthSummary

        return host.hostname,host.ipAddress,host.healthSummary



    #     for host in hosts:
    #         hostid = host.hostId
    #         hostname = host.hostname
    #         ipaddress = host.ipAddress
    #         status = host.healthSummary
    # #        if ipaddress == '10.7.177.234':
    # #            print "NN"
    #         print ipaddress + " " + hostname + " " + hostid
    #         roles = host.roleRefs
    #         for r in roles:
    #             rolename = r.roleName
    #             servicename = r.serviceName
    #             print "     " + servicename + " " + rolename
    #
    # #    print "[" + servicename + "/" + rolename + "] " + ipaddress + " " + hostname + " " + hostid

if __name__ == '__main__':


    parser = argparse.ArgumentParser(description='Filter CDH5 hosts')
    parser.add_argument('--service', required=False, type=str,default="ALL", help='Filter by service')
    parser.add_argument('--role', required=False, type=str,default="ALL", help='Filter by role')
    parser.add_argument('--host', required=False, type=str,default="ALL", help='Filter by hostname ')
    parser.add_argument('--list', required=False, type=str,default="NO", help='output list of IpAddress ')

    args=parser.parse_args()
    cdh5_hosts = cm_utils(**vars(args))
    cdh5_hosts.main()




